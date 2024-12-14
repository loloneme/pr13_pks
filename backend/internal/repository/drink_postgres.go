package repository

import (
	"database/sql"
	"fmt"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
	"github.com/loloneme/pr13/backend/internal/entities"
	"log"
)

type DrinkPostgres struct {
	db *sqlx.DB
}

func NewDrinkPostgres(db *sqlx.DB) *DrinkPostgres {
	return &DrinkPostgres{db: db}
}

func (r *DrinkPostgres) CreateDrink(drink *entities.Drink) (int64, error) {
	var drinkID int64
	query := `INSERT INTO "drink" (name, image, description, compound, is_cold, is_hot) VALUES ($1, $2, $3, $4, $5, $6) RETURNING drink_id`

	err := r.db.QueryRowx(query, drink.Name, drink.ImageURL, drink.Description, drink.Compound, drink.Cold, drink.Hot).Scan(&drinkID)
	if err != nil {
		return 0, fmt.Errorf("error creating drink: %v", err)
	}

	for _, vol := range drink.Volumes {
		_, err := r.db.Exec(`
            INSERT INTO volumes (drink_id, volume, price)
            VALUES ($1, $2, $3);
        `, drinkID, vol.Volume, vol.Price)

		if err != nil {
			return 0, fmt.Errorf("error creating volume %s for drink %d: %v", vol.Volume, drinkID, err)
		}
	}

	return drinkID, nil
}

func (r *DrinkPostgres) GetDrinkByID(drinkID int64) (*entities.Drink, error) {
	var res entities.Drink

	query := `
        SELECT drink_id, name, image, description, compound, is_cold, is_hot
        FROM drink
        WHERE drink_id = $1;
    `

	err := r.db.Get(&res, query, drinkID)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("drink %d not found", drinkID)
		}
		return nil, fmt.Errorf("error getting drink: %v", err)
	}

	volumesQuery := `
        SELECT volume_id, volume, price
        FROM volumes
        WHERE drink_id = $1;
    `
	rows, err := r.db.Query(volumesQuery, drinkID)
	if err != nil {
		return nil, fmt.Errorf("error getting volumes: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var vol entities.Volume
		if err := rows.Scan(&vol.ID, &vol.Volume, &vol.Price); err != nil {
			return nil, fmt.Errorf("error reading volumes: %v", err)
		}
		res.Volumes = append(res.Volumes, vol)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return &res, nil
}

func (r *DrinkPostgres) GetDrinks(userID string) ([]*entities.Drink, error) {
	drinksQuery := `
        SELECT drink_id, name, image, description, compound, is_cold, is_hot
        FROM drink;
    `

	var drinks []*entities.Drink
	err := r.db.Select(&drinks, drinksQuery)
	if err != nil {
		return nil, fmt.Errorf("error getting drinks: %v", err)
	}

	for i := range drinks {
		if userID != "" {
			isFavorite, err := r.GetFavoriteStatus(drinks[i].ID, userID)
			if err != nil {
				return nil, err
			}
			drinks[i].IsFavorite = isFavorite
		}

		volumeQuery := `SELECT volume, price
						FROM volumes 
						WHERE drink_id = $1`

		err := r.db.Select(&drinks[i].Volumes, volumeQuery, drinks[i].ID)
		if err != nil {
			log.Printf("error getting volumes for drink ID %d: %v", drinks[i].ID, err)
			continue
		}
	}

	if drinks == nil {
		drinks = []*entities.Drink{}
	}

	return drinks, nil
}

func (r *DrinkPostgres) DeleteDrink(drinkID int64) error {
	_, err := r.db.Exec(`DELETE FROM "drink"  WHERE drink_id=$1`, drinkID)

	return err
}

func (r *DrinkPostgres) UpdateDrink(drink *entities.Drink) error {
	query := `
        UPDATE drink
        SET name = $1, image = $2, description = $3, compound = $4, 
            is_cold = $5, is_hot = $6
        WHERE drink_id = $7;
    `

	_, err := r.db.Exec(query, drink.Name, drink.ImageURL, drink.Description,
		drink.Compound, drink.Cold, drink.Hot, drink.ID)
	if err != nil {
		return fmt.Errorf("error updating drink: %v", err)
	}

	volumeList := make([]string, 0, len(drink.Volumes))
	for _, vol := range drink.Volumes {
		volumeList = append(volumeList, vol.Volume)
	}

	deleteVolumesQuery := `DELETE FROM volumes WHERE drink_id = $1 AND volume != ALL($2);`

	_, err = r.db.Exec(deleteVolumesQuery, drink.ID, pq.Array(volumeList))
	if err != nil {
		return fmt.Errorf("error deleting old volumes: %v", err)
	}

	for _, v := range drink.Volumes {
		updateVolumeQuery := `
            UPDATE volumes
            SET price = $1
            WHERE drink_id = $2 AND volume = $3;
        `
		res, err := r.db.Exec(updateVolumeQuery, v.Price, drink.ID, v.Volume)
		if err != nil {
			return fmt.Errorf("error updating volume: %v", err)
		}

		rowsAffected, err := res.RowsAffected()
		if err != nil {
			return err
		}

		if rowsAffected == 0 {
			insertVolumeQuery := `
                INSERT INTO volumes (drink_id, volume, price) 
                VALUES ($1, $2, $3);
            `
			_, err := r.db.Exec(insertVolumeQuery, drink.ID, v.Volume, v.Price)
			if err != nil {
				return fmt.Errorf("error inserting new volume: %v", err)
			}
		}
	}

	return nil
}

func (r *DrinkPostgres) ToggleFavorite(drinkID int64, userID string) error {
	isFavorite, err := r.GetFavoriteStatus(drinkID, userID)
	if err != nil {
		return err
	}

	if isFavorite {
		query := `DELETE FROM favorites WHERE drink_id = $1 AND user_id = $2;`

		_, err := r.db.Exec(query, drinkID, userID)
		if err != nil {
			return fmt.Errorf("error deleting from favorites: %v", err)
		}
	} else {
		query := `INSERT INTO favorites (user_id, drink_id) VALUES ($1, $2);`

		_, err := r.db.Exec(query, userID, drinkID)
		if err != nil {
			return fmt.Errorf("error inserting to favorites: %v", err)
		}
	}
	return nil

}

func (r *DrinkPostgres) GetFavoriteStatus(drinkID int64, userID string) (bool, error) {
	query := `SELECT EXISTS (SELECT 1 FROM favorites WHERE drink_id = $1 AND user_id = $2);`

	isFavorite := false
	err := r.db.Get(&isFavorite, query, drinkID, userID)
	if err != nil {
		return false, fmt.Errorf("error with favorites: %v", err)
	}
	return isFavorite, nil
}
