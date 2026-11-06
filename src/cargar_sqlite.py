"""
cargar_sqlite.py
Carga el CSV limpio en una base de datos SQLite para consultarla con SQL.
Uso: python src/cargar_sqlite.py
"""
from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent
CLEAN = BASE / "data" / "clean" / "powerlifting_clean.csv"
DB = BASE / "data" / "powerlifting.db"


def main():
    # Si la base ya existe, la borramos para empezar de cero.
    if DB.exists():
        DB.unlink()

    conn = sqlite3.connect(DB)

    # Leemos el CSV por partes (chunks) para no cargar todo en memoria de golpe.
    total = 0
    for chunk in pd.read_csv(CLEAN, chunksize=200_000):
        chunk.to_sql("powerlifting", conn, if_exists="append", index=False)
        total += len(chunk)
        print(f"Cargadas {total:,} filas")

    # Los índices aceleran las consultas que filtran o agrupan por estas columnas.
    conn.execute("CREATE INDEX idx_pais ON powerlifting(MeetCountry)")
    conn.execute("CREATE INDEX idx_nombre ON powerlifting(Name)")
    conn.execute("CREATE INDEX idx_anio ON powerlifting(Year)")

    conn.commit()
    conn.close()
    print(f"Base creada en {DB}")


if __name__ == "__main__":
    main()