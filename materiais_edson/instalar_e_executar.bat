@echo off
echo ========================================
echo  INSTALADOR E EXTRATOR DE COMENTARIOS PDF
echo ========================================
echo.

echo Instalando bibliotecas Python necessarias...
pip install PyMuPDF pdfplumber PyPDF2

echo.
echo Executando extrator completo...
python extract_pdf_comments.py

echo.
echo Caso o extrator completo falhe, tentando versao simples...
python simple_pdf_extractor.py

echo.
echo ========================================
echo  CONCLUIDO!
echo ========================================
echo.
echo Verifique os arquivos gerados nesta pasta:
echo - pdf_comments_*.json (dados estruturados)
echo - pdf_comments_*.txt (texto legivel)
echo - pdf_text_*.txt (texto do PDF)
echo.
pause