# Vector Databases

A vector database stores **embeddings** (lists of numbers that represent text, images or audio) and finds the items whose vectors are closest to a query vector.

## Vectors and embeddings
- `"apple"` → `[0.21, -0.45, 0.78, ..., 0.12]`
- A cat photo → `[0.3, 0.2, -0.9, ..., 0.8]`

Items with similar meaning have vectors that are close together.

## How it works
1. **Ingestion:** a machine-learning model converts data into vectors.
2. **Indexing:** approximate nearest-neighbour structures such as HNSW (graph) or IVF (clusters) make search fast.
3. **Similarity search:** returns the nearest vectors using cosine similarity, Euclidean distance or dot product.

## SQL database vs vector database
| Feature | Relational | Vector |
|---|---|---|
| Stores | Rows of structured values | High-dimensional vectors plus metadata |
| Query | Exact match / ranges (`WHERE name = 'Ali'`) | Nearest neighbours ("most similar") |
| Index | B-tree | HNSW, IVF, PQ |

## Common systems
FAISS (library), Milvus, Pinecone (managed), Weaviate, Qdrant, Chroma, PostgreSQL with `pgvector`.

## Applications
- Image search (find similar pictures)
- Product and movie recommendations
- Song identification and audio matching
- Semantic text search and question answering
- Fraud and anomaly detection
