package utils

type Comparable interface {
	int | int8 | int16 | int32 | int64 | uint | uint8 | uint16 | uint32 | uint64 | float32 | float64 | string
}

func MaxKey[T Comparable, K any](data map[T]K) T {
	var maxKey T
	for key := range data {
		if key > maxKey {
			maxKey = key
		}
	}
	return maxKey
}
