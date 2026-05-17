export interface Film { id: number; title: string; description?: string; category: string; releaseDate?: string; rating: number; posterUrl?: string; }
export interface FilmVersion { id: number; filmId: number; format: string; resolution?: string; language: string; isAvailable: boolean; }
export interface Actor { id: number; stageName: string; firstName: string; lastName: string; birthDate?: string; performanceComment?: string; }
export interface Client { id: number; firstName: string; lastName: string; phoneHome: string; address?: string; city: string; email?: string; phoneMobile?: string; }
export interface Viewing { id: number; clientId: number; filmId: number; versionId: number; viewedAt?: string; durationMinutes?: number; status: string; filmTitle?: string; }
export interface Vote { id: number; clientId: number; filmId: number; score: number; commentText?: string; votedAt?: string; }
export interface VoteTag { id: number; tagName: string; }
export interface ClientProfile { mostWatchedCategory?: string; averageVoteScore?: number; topActor?: string; topTag?: string; totalViewings?: number; }
export interface SentimentResult { sentiment: string; score: number; }
export interface ClientCluster { clientId: number; clientName: string; dominantCategory: string; clusterLabel: string; }
export interface SeasonalPrediction { filmId: number; title: string; category: string; rating: number; viewCount: number; }
export interface VoteRequest { vote: Vote; tagIds: number[]; }
