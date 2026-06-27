import os

import psycopg


def main():
    with psycopg.connect(
        host=os.environ["DB_HOST"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    ) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS images (
                    id UUID PRIMARY KEY,
                    original_filename TEXT NOT NULL,
                    original_bucket TEXT NOT NULL,
                    original_key TEXT NOT NULL,
                    processed_bucket TEXT,
                    processed_key TEXT,
                    status TEXT NOT NULL,
                    width INTEGER,
                    height INTEGER,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                    processed_at TIMESTAMPTZ
                );
            """)

        conn.commit()

    print("Schema created successfully.")


if __name__ == "__main__":
    main()