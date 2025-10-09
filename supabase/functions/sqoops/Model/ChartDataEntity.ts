
export type ChartDataEntity = {
    id: string; // 플레이리스트 ID
    date: Date; // 클라이언트 전송 날짜 (UTC 시간 반영 위함)
    locale: string | null; // 지역 코드
    channelID: string; // 채널 ID
};