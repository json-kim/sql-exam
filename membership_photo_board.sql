-- 0. 테이블 구성 쿼리

-- 회원 테이블
CREATE TABLE member(
    _id VARCHAR(12) NOT NULL,
    name VARCHAR(12) NOT NULL,
    password VARCHAR(12) NOT NULL,
    PRIMARY KEY(_id)
) ENGINE = INNODB default character set utf8 collate utf8_general_ci;

-- 게시물 테이블
CREATE TABLE board(
    _id INT AUTO_INCREMENT,
    title VARCHAR(32) NOT NULL,
    member_id VARCHAR(12) NOT NULL,
    photo_id INT NOT NULL,
    date DATETIME NOT NULL,
    content TEXT,
    PRIMARY KEY(_id)
) ENGINE = INNODB default character set utf8 collate utf8_general_ci;

-- 사진 테이블
CREATE TABLE photo(
    _id INT AUTO_INCREMENT,
    url VARCHAR(100),
    PRIMARY KEY(_id)
) ENGINE = INNODB default character set utf8 collate utf8_general_ci;

--------------------------------------------------------

-- 1. 회원가입 쿼리

-- 1) id, name, password를 입력받고
-- 2) 입력값 모두 형식에 맞게 입력되었다고 가정
-- 3) id가 중복되었는지 체크
SELECT
    COUNT(*)
FROM
    member
WHERE
    _id = "input_id"
;

-- 4) 중복된 id가 없을 경우 member테이블에 INSERT
INSERT INTO member
    (_id, name, password)
VALUES
    ("input_id", "김재승", "12345678")
;

--------------------------------------------------------

-- 2. 게시판 리스트 쿼리

-- 1) board테이블에서 데이터를 가져온다. (최신순으로 20개만)
SELECT
    board.*,
    (SELECT
        name
    FROM
        member
    WHERE
        _id = board.member_id  
    )
FROM
    board as board
ORDER BY board.date DESC
LIMIT 20
;

-- 2) 제목, 작성자 이름을 입력받는다.
-- 3) 제목을 가지고 게시물을 가져온다.
SELECT
    board.*,
    (SELECT
        name
    FROM
        member
    WHERE
        _id = board.member_id  
    )
FROM
    board as board
WHERE
    title LIKE "%제목%"
ORDER BY board.date DESC
LIMIT 20
;

-- 4) 작성자 이름을 가지고 게시물을 가져온다.
SELECT
    board.*,
    (SELECT
        name
    FROM
        member
    WHERE
        _id = board.member_id  
    )
FROM
    board as board
WHERE
    board.member_id = (
        SELECT
            _id
        FROM
            member
        WHERE
            name = "김재승"
    )
ORDER BY board.date DESC
LIMIT 20
;

--------------------------------------------------------

-- 3. 게시물 등록 쿼리

-- 1) 회원이 게시물 제목, 게시물 내용, 사진 url을 입력한다.
-- 2) 사진 url을 photo 테이블에 INSERT하고 그 _id를 가져온다.
INSERT INTO photo
    (url)
VALUES
    ('https://url')
;

-- 3) 일단 수동으로 사진 _id를 확인하고 회원 _id와 입력된 게시물 데이터를 함계 board테이블에 INSERT한다.
-- date에는 현재 시간을 넣어준다.
INSERT INTO board
    (title, member_id, photo_id, date, content)
VALUES
    ('제목1', 'input_id', 1, NOW(), '입력 내용')
;

--------------------------------------------------------

-- 4. 게시물 삭제 쿼리

-- 1) 회원이 게시물 _id를 가지고 삭제 요청을 한다.
-- 2) 해당 게시물이 요청을 한 회원의 게시물인지 체크한다.
-- 쿼리 결과가 0보다 크면 다음 삭제 동작 수행,
-- 그게 아니라면 삭제 요청 거절
SELECT
    COUNT(*)
FROM
    board
WHERE
    _id = 1 -- 게시물의 ID
AND
    member_id = 'input_id'
;

-- 3) 게시물 _id를 가지고 board테이블에서 삭제 동작 수행
-- 사진부터 삭제
DELETE FROM
    photo
WHERE
    _id = (
        SELECT
            photo_id
        FROM
            board
        WHERE
            _id = 1 -- 게시물의 ID
    )
;

-- 게시물도 삭제
DELETE FROM
    board
WHERE
    _id = 1
;

--------------------------------------------------------

-- 5. 게시물 수정 쿼리

-- 1) 회원이 게시물 _id와 수정할 내용 (title, content, 사진 url)을 가지고 수정 요청
-- 2) 해당 게시물이 요청을 한 회원의 게시물인지 체크한다.
-- 쿼리 결과가 0보다 크면 다음 삭제 동작 수행,
-- 그게 아니라면 삭제 요청 거절
SELECT
    COUNT(*)
FROM
    board
WHERE
    _id = 1 -- 게시물의 ID
AND
    member_id = 'input_id'
;

-- 3) 게시물 _id를 가지고 사진을 update하고, 게시물을 update
UPDATE
    photo
SET
    url = 'https://수정url'
WHERE
    _id = (
        SELECT
            photo_id
        FROM
            board
        WHERE
            _id = 1 -- 게시물의 ID
    )
;

UPDATE
    board
SET
    title = '수정 제목',
    content = '수정 내용'
WHERE
    _id = 1 -- 게시물의 ID
;