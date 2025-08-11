import os

def generate_tree(directory, prefix=""):
    contents = os.listdir(directory)
    for index, content in enumerate(contents):
        path = os.path.join(directory, content)
        is_last = index == len(contents) - 1
        connector = "└── " if is_last else "├── "
        print(prefix + connector + content)
        if os.path.isdir(path):
            extension = "    " if is_last else "│   "
            generate_tree(path, prefix + extension)

generate_tree(".")
