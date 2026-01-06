library(bslib)

# Test 1: scalar value
vb1 = value_box(title = "Scalar", value = 0.5)
print("Scalar value_box:")
print(vb1)

# Test 2: vector of length 1
vb2 = value_box(title = "Vector", value = c(0.5))
print("\nVector value_box:")
print(vb2)

# Test 3: what round() returns on a vector
x = c(0.5)
rounded = round(x, 3)
print("\nClass of rounded vector:")
print(class(rounded))
print("Length:")
print(length(rounded))

vb3 = value_box(title = "Rounded Vector", value = rounded)
print("\nRounded vector value_box:")
print(vb3)

# Test 4: Extract scalar with [[1]]
vb4 = value_box(title = "Extracted Scalar", value = rounded[[1]])
print("\nExtracted scalar value_box:")
print(vb4)
