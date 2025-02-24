import gdown
import zipfile
import os
import shutil

root_folder_drive = "https://drive.google.com/drive/folders/14DtUb0uVMmiHpWvLZaUl9VxbamYnb4HJ"

datasets = {
    "imdb": ["data", "parquet-zstd"],
    "ce": ["data", "parquet-zstd"],
    "stats-ceb": ["data", "data-lowercase", "parquet-zstd", "parquet-zstd-lowercase"],
}

cache_dir = ".data_cache"

# Make a directory to store the data
os.makedirs(cache_dir, exist_ok=True)

gdown.download_folder(url=root_folder_drive, output=cache_dir, quiet=False)


# Unzip each of the files in their correct directories
for dataset in datasets:
    # First create the directory
    os.makedirs(dataset, exist_ok=True)
    # Unzip the files
    for file in datasets[dataset]:
        print(f"Unzipping {file} for {dataset}")
        file_path = f"{cache_dir}/{dataset}/{file}.zip"
        with zipfile.ZipFile(file_path, "r") as zip_ref:
            zip_ref.extractall(f"{dataset}")

# Remove the cache directory
print("Removing cache directory")
shutil.rmtree(cache_dir)
