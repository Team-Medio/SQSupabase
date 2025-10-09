# 📊 플레이리스트 스쿱 분포 차트

## 차트를 PNG로 저장하는 방법

### 1. Mermaid Live Editor 사용
1. [Mermaid Live Editor](https://mermaid.live) 접속
2. 아래 `.mmd` 파일 내용을 복사해서 붙여넣기
3. "Actions" → "Download PNG" 클릭

### 2. VS Code Extension 사용
1. "Mermaid Preview" 확장 프로그램 설치
2. `.mmd` 파일 열기
3. 미리보기에서 우클릭 → "Export" → "PNG"

### 3. CLI 도구 사용
```bash
# Mermaid CLI 설치
npm install -g @mermaid-js/mermaid-cli

# PNG로 변환
mmdc -i chart_bar.mmd -o chart_bar.png
mmdc -i chart_pie.mmd -o chart_pie.png
```

## 파일 목록
- `chart_bar.mmd`: 막대 그래프 (스쿱 횟수별 플레이리스트 수)
- `chart_pie.mmd`: 원형 그래프 (스쿱 횟수별 비율 분포)

## 데이터 요약
- **총 플레이리스트**: 7,151개
- **평균 스쿱**: 2.58회
- **중앙값**: 1회
- **최대 스쿱**: 168회
- **1회만 스쿱**: 62.47% (4,467개)

