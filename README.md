# Aplicativo de Consulta de Dados COVID-19 por País

Este aplicativo foi desenvolvido em Delphi 12 (Athena) com a finalidade de consultar dados atualizados sobre a COVID-19 por país, consumindo dados de uma API pública.  

O projeto **não utiliza nenhum componente adicional**, apenas os que já acompanham a instalação padrão do Delphi 12.

## 🚀 Como utilizar

1. **Execute o programa**:  
   Ao iniciar, o aplicativo já carrega automaticamente os dados da API.

2. **Filtrar por país**:  
   Para buscar informações específicas de um país, digite o nome no campo de busca. O filtro é aplicado dinamicamente, conforme você digita.

3. **Limpar filtro**:  
   Para visualizar novamente todos os dados, clique no botão **"Limpar busca"**.

4. **Ordenar colunas**:  
   É possível ordenar os dados clicando nos títulos das colunas. A ordenação está habilitada apenas para:
   - País
   - Casos Confirmados
   - Mortes

## 💡 Funcionalidades

- Carregamento automático de dados ao iniciar.
- Exibição de mensagens informativas em caso de falha na requisição ou no processamento dos dados.
- Filtro por nome do país com atualização em tempo real.
- Ordenação de colunas selecionadas para facilitar a análise dos dados.

## 📁 Estrutura do Código

O código está comentado com explicações nas principais seções, incluindo:

- A conexão com a API e tratamento de respostas.
- A rotina de preenchimento do dataset.
- A implementação da ordenação e filtragem.
- Mensagens de erro tratadas com janelas dialogadas amigáveis.

## ❗ Requisitos

- Delphi 12 Athens (sem componentes adicionais)
