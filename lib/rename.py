import os
import re
import sys

# Cyrillic to Latin transliteration map
CYRILLIC_TO_LATIN = {
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo', 'ж': 'zh',
    'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o',
    'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'ts',
    'ч': 'ch', 'ш': 'sh', 'щ': 'sch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya',
    'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo', 'Ж': 'Zh',
    'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M', 'Н': 'N', 'О': 'O',
    'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U', 'Ф': 'F', 'Х': 'H', 'Ц': 'Ts',
    'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Sch', 'Ъ': '', 'Ы': 'Y', 'Ь': '', 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya'
}

def transliterate_cyrillic(text):
    """Transliterate Cyrillic characters to ASCII, ignore other non-ASCII chars"""
    result = []
    for char in text:
        if char in CYRILLIC_TO_LATIN:
            result.append(CYRILLIC_TO_LATIN[char])
        elif ord(char) < 128:  # ASCII character
            result.append(char)
            # else: ignore non-ASCII non-Cyrillic characters
    return ''.join(result)

def clean_filename(filename):
    # Transliterate Cyrillic and remove non-ASCII
    filename = transliterate_cyrillic(filename)
    # Remove invalid chars
    filename = re.sub(r'[^a-zA-Z0-9 _.-]', '_', filename)
    # Replace spaces with underscores
    filename = filename.replace(' ', '_')
    # Replace minus with underscores
    filename = filename.replace('-', '_')
    # Remove consecutive underscores
    filename = re.sub(r'_+', '_', filename)
    # Strip leading/trailing underscores or dots
    filename = filename.strip('_').strip('.')
    # lowercase
    filename = filename.lower()
    return filename

def rename_files_in_directory(directory):
    extensions = ('.pdf', '.epub')
    total_files = 0
    renamed_files = 0

    # Only process files at the first level, not in nested directories
    for item in os.listdir(directory):
        item_path = os.path.join(directory, item)
        # Skip directories
        if os.path.isdir(item_path):
            continue

        if item.lower().endswith(extensions):
            total_files += 1
            old_path = item_path
            name, ext = os.path.splitext(item)
            new_name = clean_filename(name) + ext
            new_path = os.path.join(directory, new_name)

            if old_path != new_path:
                if os.path.exists(new_path):
                    print(f"[SKIP] {item} (target exists) old_path={old_path} new_path={new_path}")
                else:
                    os.rename(old_path, new_path)
                    print(f"[RENAMED] {item} -> {new_name}")
                    renamed_files += 1
            else:
                print(f"[UNCHANGED] {item}")

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
