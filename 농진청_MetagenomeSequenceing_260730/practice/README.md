
# Metagenome Amplicon 분석 실습 (QIIME2 2026.4)

본 폴더는 **농촌진흥청 메타제놈 앰플리콘(16S rRNA) 분석 교육**을 위한 실습 데이터 및 실행 환경 설정 가이드를 담고 있습니다.

---

## 1. 환경 세팅 (QIIME2 Docker)

> **참고:** `quay.io/qiime2/qiime2:2026.4` 이미지는 시스템 관리자에 의해 사전 설치가 완료되어 있습니다.  
> (개인 환경 구축 시: `docker pull quay.io/qiime2/qiime2:2026.4`)

### 사용자 단축 명령어 설정
매번 길고 복잡한 Docker 실행 명령어를 입력하지 않도록 `~/.bashrc`에 단축 함수를 등록합니다.

1. `~/.bashrc` 파일을 엽니다.
   ```bash
   vi ~/.bashrc

2. 파일(`~/.bashrc`) 하단에 아래 코드 추가
   ```bash
   qiime-docker() {
       docker run --rm \
           --user $(id -u):$(id -g) \
           -e HOME=/tmp \
           -e MPLCONFIGDIR=/tmp/matplotlib \
           -v "$PWD":/data \
           -w /data \
           -ti quay.io/qiime2/qiime2:2026.4 \
           qiime "$@"
   }

4. 변경 사항을 즉시 적용합니다.
   ```bash
   source ~/.bashrc

6. 등록 확인 (버전 출력 테스트)
   ```bash
   qiime-docker --version


## 실습 데이터 다운로드
분석 실습에 필요한 메타데이터(sample-metadata.tsv) 및 시퀀싱 데이터(demux.qza)를 다운로드합니다. 터미널에서 아래 명령어를 실행하세요.
   ```bash
   # 메타데이터 다운로드
   wget -O 'sample-metadata.tsv' 'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/sample-metadata.tsv'

   # QIIME2 FORMAT(.qza) 서열데이터 다운로드
   ```bash
   wget -O 'demux.qza' 'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/demux.qza'
