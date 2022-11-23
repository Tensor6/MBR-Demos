from PIL import Image
import sys

if len(sys.argv) < 2:
    print("Not enough arguments")
    sys.exit(1)

image = Image.open(sys.argv[1])
pixels = image.load()

w = image.width
h = image.height

out_file = open("image.bin", "wb")

bytesWritten = 0

for y in range(h):
    for x in range(w):
        bytesWritten += out_file.write(int.to_bytes(pixels[x,y], 1, 'little'))

out_file.flush()
out_file.close()
print(f"{bytesWritten} bytes written!")