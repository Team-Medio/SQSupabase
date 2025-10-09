import "jsr:@supabase/functions-js/edge-runtime.d.ts";

export enum FilterType {
    RECENT = "recent",
    MOST = "most"
};

export enum PeriodType {
    WEEK = "week",
    MONTH = "month"
};

export type InsertValueModel_v1 = {
    id: string; // 플레이리스트 ID
    date: Date; // 클라이언트 전송 날짜 (UTC 시간 반영 위함)
    locale: string | null; // 지역 코드
};

export type MostSqoopedModel_v1 = {
    id: string; // 플레이리스트 ID
    sqoopCount: number; // 스쿱 개수
    count: number;
};

// 마이그레이션 대상... 채널 ID 추가
export type InsertValueModel_v2 = {
    id: string; // 플레이리스트 ID
    date: Date; // 클라이언트 전송 날짜 (UTC 시간 반영 위함)
    locale: string | null; // 지역 코드
    channelID: string; // 채널 ID
};