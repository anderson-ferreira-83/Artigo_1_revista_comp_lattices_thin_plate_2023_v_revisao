#!/usr/bin/env python3
"""
Extrator de Comentários e Anotações de PDF
===========================================
Script para extrair comentários, anotações e highlights de arquivos PDF
usando PyMuPDF (fitz) e outras bibliotecas Python.

Uso:
    python extract_pdf_comments.py

Desenvolvido para extrair comentários do arquivo response_to_reviewers_rev1.pdf
"""

import sys
import os
from pathlib import Path
import json
from datetime import datetime

def install_requirements():
    """Instala as bibliotecas necessárias se não estiverem disponíveis."""
    required_packages = [
        'PyMuPDF',  # fitz
        'pdfplumber',
        'PyPDF2'
    ]
    
    print("=== INSTALANDO DEPENDÊNCIAS ===")
    for package in required_packages:
        try:
            if package == 'PyMuPDF':
                import fitz
                print(f"✓ {package} já instalado")
            elif package == 'pdfplumber':
                import pdfplumber
                print(f"✓ {package} já instalado")
            elif package == 'PyPDF2':
                import PyPDF2
                print(f"✓ {package} já instalado")
        except ImportError:
            print(f"⚠ Instalando {package}...")
            os.system(f"pip install {package}")
    print()

def extract_comments_with_pymupdf(pdf_path):
    """
    Extrai comentários usando PyMuPDF (fitz) - melhor para anotações.
    
    Args:
        pdf_path (str): Caminho para o arquivo PDF
        
    Returns:
        list: Lista de dicionários com comentários encontrados
    """
    try:
        import fitz
    except ImportError:
        print("❌ PyMuPDF não está instalado. Execute: pip install PyMuPDF")
        return []
    
    print(f"📖 Abrindo PDF: {pdf_path}")
    doc = fitz.open(pdf_path)
    comments = []
    
    for page_num in range(len(doc)):
        page = doc[page_num]
        print(f"   Analisando página {page_num + 1}...")
        
        # Buscar todas as anotações na página
        annotations = page.annots()
        
        for annot in annotations:
            try:
                # Extrair informações da anotação
                annot_dict = annot.info
                content = annot_dict.get("content", "")
                title = annot_dict.get("title", "")
                
                if content or title:  # Só adicionar se tiver conteúdo
                    comment_data = {
                        "page": page_num + 1,
                        "type": annot.type[1],  # Tipo da anotação
                        "content": content,
                        "title": title,
                        "author": annot_dict.get("name", ""),
                        "rect": list(annot.rect),  # Coordenadas [x0, y0, x1, y1]
                        "creation_date": annot_dict.get("creationDate", ""),
                        "modification_date": annot_dict.get("modDate", "")
                    }
                    comments.append(comment_data)
                    print(f"     ✓ Encontrado: {annot.type[1]} - {content[:50]}...")
            except Exception as e:
                print(f"     ⚠ Erro ao processar anotação: {e}")
                continue
    
    doc.close()
    print(f"✓ Análise concluída. {len(comments)} comentários encontrados.\n")
    return comments

def extract_text_with_pdfplumber(pdf_path):
    """
    Extrai texto do PDF usando pdfplumber.
    
    Args:
        pdf_path (str): Caminho para o arquivo PDF
        
    Returns:
        str: Texto extraído do PDF
    """
    try:
        import pdfplumber
    except ImportError:
        print("❌ pdfplumber não está instalado. Execute: pip install pdfplumber")
        return ""
    
    print(f"📄 Extraindo texto do PDF...")
    full_text = ""
    
    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages):
            print(f"   Página {page_num + 1}...")
            text = page.extract_text()
            if text:
                full_text += f"\n=== PÁGINA {page_num + 1} ===\n"
                full_text += text + "\n"
    
    print(f"✓ Texto extraído ({len(full_text)} caracteres).\n")
    return full_text

def save_results(comments, pdf_text, output_dir):
    """
    Salva os resultados em arquivos separados.
    
    Args:
        comments (list): Lista de comentários
        pdf_text (str): Texto do PDF
        output_dir (str): Diretório para salvar os arquivos
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Salvar comentários em JSON
    comments_file = f"{output_dir}/pdf_comments_{timestamp}.json"
    with open(comments_file, 'w', encoding='utf-8') as f:
        json.dump(comments, f, indent=2, ensure_ascii=False)
    print(f"💾 Comentários salvos: {comments_file}")
    
    # Salvar comentários em formato texto legível
    comments_txt_file = f"{output_dir}/pdf_comments_{timestamp}.txt"
    with open(comments_txt_file, 'w', encoding='utf-8') as f:
        f.write(f"COMENTÁRIOS EXTRAÍDOS DO PDF\n")
        f.write(f"{'='*50}\n")
        f.write(f"Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n")
        f.write(f"Total de comentários: {len(comments)}\n\n")
        
        for i, comment in enumerate(comments, 1):
            f.write(f"COMENTÁRIO {i}\n")
            f.write(f"Página: {comment['page']}\n")
            f.write(f"Tipo: {comment['type']}\n")
            f.write(f"Título: {comment['title']}\n")
            f.write(f"Autor: {comment['author']}\n")
            f.write(f"Conteúdo: {comment['content']}\n")
            f.write(f"Data criação: {comment['creation_date']}\n")
            f.write(f"Data modificação: {comment['modification_date']}\n")
            f.write(f"Coordenadas: {comment['rect']}\n")
            f.write(f"{'-'*40}\n\n")
    
    print(f"📝 Comentários (texto) salvos: {comments_txt_file}")
    
    # Salvar texto do PDF
    text_file = f"{output_dir}/pdf_text_{timestamp}.txt"
    with open(text_file, 'w', encoding='utf-8') as f:
        f.write(f"TEXTO EXTRAÍDO DO PDF\n")
        f.write(f"{'='*50}\n")
        f.write(f"Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n\n")
        f.write(pdf_text)
    
    print(f"📄 Texto do PDF salvo: {text_file}")

def main():
    """Função principal do script."""
    print("🔍 EXTRATOR DE COMENTÁRIOS PDF")
    print("="*40)
    
    # Definir caminhos
    current_dir = Path(__file__).parent
    pdf_file = current_dir / "response_to_reviewers_rev1.pdf"
    output_dir = current_dir
    
    # Verificar se o arquivo existe
    if not pdf_file.exists():
        print(f"❌ Arquivo não encontrado: {pdf_file}")
        print("   Verifique se o arquivo está no mesmo diretório do script.")
        return
    
    # Instalar dependências
    install_requirements()
    
    try:
        # Extrair comentários
        print("🔍 ETAPA 1: Extraindo comentários e anotações...")
        comments = extract_comments_with_pymupdf(str(pdf_file))
        
        # Extrair texto
        print("🔍 ETAPA 2: Extraindo texto do PDF...")
        pdf_text = extract_text_with_pdfplumber(str(pdf_file))
        
        # Salvar resultados
        print("🔍 ETAPA 3: Salvando resultados...")
        save_results(comments, pdf_text, str(output_dir))
        
        # Resumo final
        print("\n" + "="*50)
        print("✅ EXTRAÇÃO CONCLUÍDA COM SUCESSO!")
        print(f"📊 Estatísticas:")
        print(f"   • Comentários encontrados: {len(comments)}")
        print(f"   • Texto extraído: {len(pdf_text)} caracteres")
        print(f"   • Arquivos salvos em: {output_dir}")
        
        if comments:
            print(f"\n📋 RESUMO DOS COMENTÁRIOS:")
            for i, comment in enumerate(comments, 1):
                content_preview = comment['content'][:100] + "..." if len(comment['content']) > 100 else comment['content']
                print(f"   {i:2d}. [Pg {comment['page']:2d}] {comment['type']}: {content_preview}")
        else:
            print("\n⚠ NENHUM COMENTÁRIO ENCONTRADO")
            print("   Isso pode acontecer se:")
            print("   • O PDF não tem comentários/anotações")
            print("   • Os comentários estão em formato não suportado")
            print("   • O PDF está protegido ou corrompido")
            
    except Exception as e:
        print(f"\n❌ ERRO DURANTE A EXECUÇÃO:")
        print(f"   {str(e)}")
        print(f"\n🔧 POSSÍVEIS SOLUÇÕES:")
        print(f"   • Verifique se o arquivo PDF não está corrompido")
        print(f"   • Instale as dependências: pip install PyMuPDF pdfplumber")
        print(f"   • Verifique as permissões do arquivo")

if __name__ == "__main__":
    main()