import os
import re
import sys

def clean_filename(filename):
    # Remove sequences in (), {}, []
    filename = re.sub(r'\[.*?\]|\(.*?\)|\{.*?\}', '', filename)
    # Replace spaces with underscores
    filename = filename.replace(' ', '_')
    # Remove consecutive underscores
    filename = re.sub(r'_+', '_', filename)
    # Strip leading/trailing underscores or dots
    filename = filename.strip('_').strip('.')
    return filename

def rename_files_in_directory(directory):
    extensions = ('.pdf', '.epub')
    total_files = 0
    renamed_files = 0

    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(extensions):
                total_files += 1
                old_path = os.path.join(root, file)
                name, ext = os.path.splitext(file)
                new_name = clean_filename(name) + ext
                new_path = os.path.join(root, new_name)
                
                if old_path != new_path:
                    if os.path.exists(new_path):
                        print(f"[SKIP] {file} (target exists)")
                    else:
                        os.rename(old_path, new_path)
                        print(f"[RENAMED] {file} -> {new_name}")
                        renamed_files += 1
                else:
                    print(f"[UNCHANGED] {file}")

    print(f"\nProcessed {total_files} files, renamed {renamed_files} files.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python rename_files.py <directory>")
        sys.exit(1)

    directory = sys.argv[1]
    if os.path.isdir(directory):
        rename_files_in_directory(directory)
    else:
        print(f"Error: '{directory}' is not a valid directory.")
