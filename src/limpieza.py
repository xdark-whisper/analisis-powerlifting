"""
limpieza.py
Limpia el dataset de OpenPowerlifting y guarda una versión lista para analizar.
Uso (desde la carpeta del proyecto, con el venv activo): python src/limpieza.py
"""
from pathlib import Path
import pandas as pd

# Rutas calculadas a partir de la ubicación de este archivo,
# así funciona sin importar desde dónde lo ejecutes.
BASE = Path(__file__).resolve().parent.parent
RAW = BASE / "data" / "raw" / "openpowerlifting.csv"
CLEAN = BASE / "data" / "clean" / "powerlifting_clean.csv"

COLUMNAS = ["Name", "Sex", "Event", "Equipment", "Age", "BodyweightKg",
            "Best3SquatKg", "Best3BenchKg", "Best3DeadliftKg",
            "TotalKg", "Dots", "Federation", "Date", "MeetCountry"]


def main():
    df = pd.read_csv(RAW, usecols=COLUMNAS, low_memory=False)
    print(f"Filas originales: {len(df):,}")

    # 1. Solo competencias completas (sentadilla + banca + peso muerto).
    # .copy() evita advertencias de pandas al modificar el resultado más abajo.
    df = df[df["Event"] == "SBD"].copy()
    print(f"Solo SBD: {len(df):,}")

    # 2. Sacar filas sin total, peso corporal o Dots (descalificados o incompletos).
    df = df.dropna(subset=["TotalKg", "BodyweightKg", "Dots"])
    print(f"Sin nulos en columnas clave: {len(df):,}")

    # 3. Eliminar filas totalmente duplicadas.
    df = df.drop_duplicates()
    print(f"Sin duplicados: {len(df):,}")

    # 4. Convertir la fecha a tipo fecha y extraer el año.
    df["Date"] = pd.to_datetime(df["Date"])
    df["Year"] = df["Date"].dt.year

    # 5. Guardar el resultado (crea la carpeta data/clean si no existe).
    CLEAN.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(CLEAN, index=False)
    print(f"Guardado en {CLEAN}")


if __name__ == "__main__":
    main()