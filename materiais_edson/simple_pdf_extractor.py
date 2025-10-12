#!/usr/bin/env python3
"""
Extrator Simples de PDF - Versão Básica
========================================
Script simplificado para extrair comentários e texto de PDF.
"""

def extract_with_basic_methods():
    """Versão básica usando apenas bibliotecas padrão quando possível."""
    
    print("🔍 EXTRATOR SIMPLES DE COMENTÁRIOS PDF")
    print("="*50)
    
    # Tentar PyMuPDF primeiro
    try:
        import fitz
        print("✓ PyMuPDF disponível - usando método avançado")
        return extract_with_pymupdf()
    except ImportError:
        print("⚠ PyMuPDF não disponível")
    
    # Tentar PyPDF2
    try:
        import PyPDF2
        print("✓ PyPDF2 disponível - usando método básico")
        return extract_with_pypdf2()
    except ImportError:
        print("⚠ PyPDF2 não disponível")
    
    print("❌ Nenhuma biblioteca PDF encontrada")
    print("📦 INSTALE UMA DAS BIBLIOTECAS:")
    print("   pip install PyMuPDF")
    print("   pip install PyPDF2")
    return None

def extract_with_pymupdf():
    """Extração usando PyMuPDF."""
    import fitz
    
    pdf_path = "response_to_reviewers_rev1.pdf"
    doc = fitz.open(pdf_path)
    
    print(f"📖 Arquivo: {pdf_path}")
    print(f"📊 Páginas: {len(doc)}")
    
    comments = []
    all_text = ""
    
    for page_num in range(len(doc)):
        page = doc[page_num]
        
        # Extrair texto
        text = page.get_text()
        all_text += f"\n=== PÁGINA {page_num + 1} ===\n{text}\n"
        
        # Extrair anotações
        for annot in page.annots():
            info = annot.info
            if info.get("content"):
                comment = {
                    "page": page_num + 1,
                    "type": annot.type[1],
                    "content": info.get("content", ""),
                    "author": info.get("title", ""),
                }
                comments.append(comment)
                print(f"✓ Comentário página {page_num + 1}: {comment['content'][:50]}...")
    
    doc.close()
    
    # Salvar resultados
    save_simple_results(comments, all_text)
    return len(comments)

def extract_with_pypdf2():
    """Extração usando PyPDF2 (limitada)."""
    import PyPDF2
    
    pdf_path = "response_to_reviewers_rev1.pdf"
    
    with open(pdf_path, 'rb') as file:
        reader = PyPDF2.PdfReader(file)
        
        print(f"📖 Arquivo: {pdf_path}")
        print(f"📊 Páginas: {len(reader.pages)}")
        
        all_text = ""
        
        for page_num, page in enumerate(reader.pages):
            text = page.extract_text()
            all_text += f"\n=== PÁGINA {page_num + 1} ===\n{text}\n"
        
        print("⚠ PyPDF2 não extrai comentários - apenas texto")
        
        # Salvar apenas texto
        save_simple_results([], all_text)
        return 0

def save_simple_results(comments, text):
    """Salva resultados de forma simples."""
    from datetime import datetime
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Salvar comentários
    if comments:
        with open(f"comentarios_{timestamp}.txt", 'w', encoding='utf-8') as f:
            f.write("COMENTÁRIOS EXTRAÍDOS\n")
            f.write("="*30 + "\n\n")
            
            for i, comment in enumerate(comments, 1):
                f.write(f"COMENTÁRIO {i}\n")
                f.write(f"Página: {comment['page']}\n")
                f.write(f"Tipo: {comment['type']}\n")
                f.write(f"Autor: {comment['author']}\n")
                f.write(f"Conteúdo:\n{comment['content']}\n")
                f.write("-" * 40 + "\n\n")
        
        print(f"💾 Comentários salvos: comentarios_{timestamp}.txt")
    
    # Salvar texto
    with open(f"texto_pdf_{timestamp}.txt", 'w', encoding='utf-8') as f:
        f.write("TEXTO DO PDF\n")
        f.write("="*20 + "\n")
        f.write(text)
    
    print(f"📄 Texto salvo: texto_pdf_{timestamp}.txt")

if __name__ == "__main__":
    import os
    
    # Verificar se arquivo existe
    if not os.path.exists("response_to_reviewers_rev1.pdf"):
        print("❌ Arquivo 'response_to_reviewers_rev1.pdf' não encontrado!")
        print("   Certifique-se de que o arquivo está no mesmo diretório.")
        exit(1)
    
    num_comments = extract_with_basic_methods()
    
    if num_comments is not None:
        print(f"\n✅ CONCLUÍDO!")
        print(f"   📊 {num_comments} comentários encontrados")
        print(f"   📁 Arquivos salvos no diretório atual")
    else:
        print(f"\n❌ FALHA - instale bibliotecas necessárias")