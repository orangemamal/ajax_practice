<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="utf-8">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0,maximum-scale=1.0">
    <title>채권 모바일전자계약 시스템 다운로드 서비스</title>
    <script src="/js/jquery-3.4.1.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <script src="/js/com-util.js"></script>
    <%--    <script defer src="/js/animation.js"></script>--%>
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/font.css">
</head>
<script>

    let count = 0;

    function getUserInfo(){
        $.ajax({
            type: "POST"
            , async: true
            , url: "/api/inicis.do"
            , beforeSend: function() {
                $.blockUI({
                    message: '<img src="/img/busy.gif" width="100"/>',
                    css: {backgroundColor: 'rgba(0,0,0,0.0)', color: '#000000', border: '0px solid #a00'}
                });
            }
            , error: function () {
                $.unblockUI();
                window.close();
            }
            , success: function (data) {
                $.unblockUI();
                $('#mid').val(data.mid);
                $('#reqSvcCd').val(data.reqSvcCd);
                $('#identifier').val(data.identifier);
                $('#mTxId').val(data.mTxId);
                $('#authHash').val(data.authHash);
                $('#flgFixedUser').val(data.flgFixedUser);
                $('#userHash').val(data.userHash);
                $('#directAgency').val(data.directAgency);
                $('#successUrl').val(data.successUrl);
                $('#failUrl').val(data.failUrl);

                callSa();

            }
        })
    };

    function callSa(){

        let window = popupComputer();
        if(window != undefined && window != null)
        {
            document.saForm.setAttribute("target", "sa_popup");
            document.saForm.setAttribute("post", "post");
            document.saForm.setAttribute("action", "https://sa.inicis.com/auth");
            document.saForm.submit();
        }
    }

    function popupComputer(){

        let _width = 400;
        let _height = 620;
        var xPos = (document.body.offsetWidth / 2) - (_width / 2); // 가운데 정렬
        xPos += window.screenLeft; // 듀얼 모니터일 때

        return window.open("", "sa_popup", "width=" + _width + ", height=" + _height + ", left=" + xPos + ", menubar=yes, status=yes, titlebar=yes, resizable=yes");

    }

    function inicisResult(code, msg, txId, mTxId, signedData, userCi, providerDevCd, name, phone, birthday){

        if (code == 'E') {
            alert("이름과 번호, 생년월일을 다시 확인해주시기 바랍니다");
        } else {

            var data = {
                txId: txId,
                mTxId: mTxId,
                signedData: signedData,
                userCi: userCi,
                providerDevCd: providerDevCd,
                name: name,
                phone: phone,
                birthday: birthday
            };
            getFileList(data);
        }
    }

    function getFileList(data){

        // var data = {
        //    name: '송성근',
        //    phone: '01081818287',
        //    birthday: '19940614'
        // }

        let html = '';

        fetch('/api/file.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        }).then(res => {
            return res.json()
        }).then(res => {
            res.forEach((obj, idx) => {
                html += `
                    <div class="replace_hr"></div>
                    <ul>
                        <div class="download_list">
                            <li>\${obj.fileName}</li>
                            <img src="/img/download_picto.png" alt="download pictogram" onClick="download('\${obj.pdfUrl}\', '\${obj.mgNo}\')">
                        </div>
                    </ul>
                `;
            });
            $('.page_wrap').css('display', 'block');
            $('.start_page_wrap').css('display', 'none');
            $('.contract_length').html("계약서 (" + res.length + ")");
            document.getElementById('tap_wrap').innerHTML = html;
        }).catch(error => {
            alert(error.toString());
        });
    }

    function fileDownload(mgNo) {

        $.ajax({
            url: '/api/fileDownload.do',
            async: true,
            type: "get",
            data: { mg_no: mgNo },
            success: function (data) {
                download(data);
                console.log(data)
                if(data === "success") {
                    console.log("success")
                    return;
                }else {
                    alert(data);
                }
            },
            error: function (data) {
                console.log("ajax error");
            }
        })
    }

    // 계약서 다운로드(PDF 생성된 프로젝트에서 로직 수행)
    function download(path, mgNo){

        if (count == 0) {
            $.ajax({
                url: '/api/upCount.do',
                async: true,
                type: "POST",
                data: { mgNo: mgNo },
                success: function (data) {
                    console.log('data = ' + data)
                    var element = document.createElement('a');
                    element.setAttribute('href', path);
                    element.style.display = 'none';
                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                    element.remove();
                },
                error: function (data) {
                    console.log("ajax error");
                }
            })
        } else {
            var element = document.createElement('a');
            element.setAttribute('href', path);
            element.style.display = 'none';
            document.body.appendChild(element);
            element.click();
            document.body.removeChild(element);
            element.remove();
        }
        count++;
    }

    function login() {
        // 로그인 로직
        console.log('login')
        $('#modal_bg_01').hide();
        $('#modal_bg_02').show();
    }

    function goStep(payload) {
        if(payload == 'main'){
            $('.blackOn').hide();
            $('.modal_bg').hide();
        }else if(payload == 'contract_01') {
            $('.blackOn').show();
            $('#modal_bg_01').show();
        }else if(payload == 'contract_03') {
            $('.subtext_wrap').hide();
            $('#modal_bg_01').show();
        }
    }

    function goBack(payload) {
        if(payload == 'main') {
            $('.modal_bg').hide();
            $('.subtext_wrap').show();
        }
    }

    function uploadFileName() {
        let file = $('#attach_file').val().split('\\');
        let fileName = file[file.length-1];
        writeFileName(fileName);
    }

    function writeFileName (fileName) {
        $('.pdf_name').text(fileName);
        $('.verify_result').text('원본 계약서 입니다');
    }



</script>
<body>
<form name="saForm">

    <input type="hidden" name="mid" id="mid"  value="">
    <input type="hidden" name="reqSvcCd" id="reqSvcCd"  value="">
    <input type="hidden" name="identifier" id="identifier"  value="">
    <input type="hidden" name="mTxId" id="mTxId"  value="">

    <input type="hidden" name="authHash" id="authHash"  value="">
    <input type="hidden" name="flgFixedUser" id="flgFixedUser"  value="">
    <input type="hidden" name="userHash"  id="userHash"  value="">
    <input type="hidden" name="directAgency" id="directAgency" value="">

    <input type="hidden" name="successUrl" id="successUrl">
    <input type="hidden" name="failUrl" id="failUrl">
    <!-- successUrl/failUrl 은 분리하여도 됩니다. !-->
</form>

<div class="bg_wrap">
    <div class="web_container">
        <div class="web_main_image_wrap">
            <img src="/img/smartphone_for_web.png" alt="contract smartphone image">
            <div class="btn_wrap_2">
                <button type="submit" class="primary_btn" onclick="goStep('contract_01')">계약서 원본확인</button>
            </div>
        </div>

        <!-- 본인확인 페이지 Start -->
        <section class="start_page_wrap">
            <header>
                <div class="header_title">모바일 채권전자계약 서비스</div>
            </header>
            <div class="mobile_container_1">
                <div class="subtext_wrap">
                    <div class="subtext_maintitle">
                        <div class="subtext_1">안전하고 간편한 모바일 채권 전자계약 서비스<br>쉽게 인지하고 빠르고 편리한 전자계약</div>
                        <div class="subtext_2">채권전자 계약서 다운로드 서비스</div>
                    </div>
                    <div class="subtext_3">본인확인 후 서비스 이용 가능합니다<br>다운로드는 계약 일로부터 일주일간 다운로드 가능합니다.</div>
                </div>
                <footer>
                    <div class="btn_wrap">
                        <button class="contract_btn" onclick="goStep('contract_03')">계약서 원본확인</button>
                        <button class="primary_btn" onclick="getUserInfo()">본인확인</button>
                    </div>
                </footer>
            </div>
        </section>

        <!-- 본인확인 페이지 End -->

        <!-- 본인확인 완료 페이지 Start -->
        <div class="page_wrap" style="display: none;">
            <header>
                <div class="header_title">모바일 채권전자계약 서비스</div>
            </header>

            <section class="mobile_container_2">

                <div class="complete_page">
                    <div class="complete_title_wrap">
                        <img src="/img/complete_picto.png" alt="complete pictogram">
                        <div class="complete_title">본인확인이 완료되었습니다.</div>
                    </div>
                    <div>하단 리스트에서 계약서를 다운 받을 수 있습니다.<br>계약서는 계약일로부터 일주일간 다운로드 가능합니다.</div>
                </div>

                <footer class="download_list_part">

                    <div class="contract_title">
                        <span class="contract_length"></span>
                        <img src="/img/arrow_bottom.png" alt="accordion pictogram" id="rotate_arrow">
                    </div>
                    <div class="tap_wrap" id="tap_wrap">
                        <%-- list --%>
                    </div>

                </footer>

            </section>
            <!-- 본인확인 완료 페이지 End -->
        </div>
    </div>

    <%--  Modal Window Start  --%>
    <div class="blackOn" style="display: none;"></div>

    <div class="modal_bg" style="display: none;" id="modal_bg_01">
        <!-- 로그인 모달 Start -->
        <div class="modal_title">계약서 원본파일 검증 서비스</div>
        <img src="/img/cancel_btn.png" alt="X" class="cancel_btn" onClick="goStep('main');">


        <div class="login_input_wrap">
            <div class="input_teil">
                <img src="/img/ID.png" alt="ID_pictogram">
                <input type="text" placeholder="ID" required id="login_id">
            </div>
            <div class="input_teil">
                <img src="/img/PASSWORD.png" alt="PASSWORD_pictogram">
                <input type="text" placeholder="PASSWORD" required id="login_pw">
            </div>
            <div class="wrong_alert">아이디가 틀렸습니다.</div>
        </div>

        <div class="info_msg">계약서 원본 파일 검증 서비스 로그인 후 이용 가능합니다.</div>
        <div class="btn_wrap">
            <button class="back_btn" onclick="goBack('main')">뒤로가기</button>
            <button class="primary_btn m0auto" id="login_btn" onclick="login()">로그인</button>
        </div>
    </div>
    <!-- 로그인 모달 End -->

    <!-- 검증 모달 Start -->
    <div class="modal_bg" style="display: none;" id="modal_bg_02">
        <div class="modal_title">계약서 원본파일 검증 서비스</div>
        <img src="/img/cancel_btn.png" alt="X" class="cancel_btn" onClick="goStep('main')">

        <div class="login_input_wrap">
            <div class="pdf_name"></div>
            <div class="verify_result">파일을 첨부해주세요</div>
        </div>
        <div class="info_msg">파일첨부 버튼을 눌러 검증받을 계약서를 첨부해주세요.</div>
        <div class="btn_wrap">
            <button class="back_btn" onclick="goBack('main')">뒤로가기</button>
            <label for="attach_file" class="primary_btn m0auto label_file">파일첨부</label>
            <input type="file" id="attach_file" accept=".pdf" onchange="uploadFileName();"/>
        </div>
        <!-- 검증 모달 End -->
    </div>

</div>
</body>
</html>