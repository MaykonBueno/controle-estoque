-- Valor total em estoque
select
sum(p.preco*p.estoque) as valor_total
from produtos p;


-- Produtos com estoque baixo estoque
select
p.nome, p.estoque, p.estoque_minimo
from produtos p
where estoque <= estoque_minimo;


-- Produto mais vendido 
select
p.nome as mais_vendido,
sum(s.quantidade) as quantidade_vendido
from produtos p
join saidas s on s.id_produto = p.id_produto
group by p.nome
order by quantidade_vendido desc
limit 1;


-- Produto menos vendido (mais que vendeu)
select 
p.nome as menos_vendido,
sum(s.quantidade) as quantidade_vendido
from produtos p
join saidas s on s.id_produto = p.id_produto
group by p.nome
order by quantidade_vendido ASC
limit 1;


-- Produtos que nunca venderam
select
p.nome as produto_parado,
p.estoque as quantidade
from produtos p
left join saidas s on s.id_produto = p.id_produto
where s.id_produto IS NULL;

-- Total vendido por produto 
select
p.nome,
sum(s.quantidade*p.preco) as total_vendido
from produtos p
join saidas s on s.id_produto = p.id_produto
group by p.nome
order by total_vendido DESC;


-- Quantidade total de entradas  por produto
select
p.nome,
sum(e.quantidade) as total_entrada
from produtos p
join entradas e on e.id_produto = p.id_produto
group by p.nome
order by total_entrada DESC;


--Diferença entre entrada e saida
select
p.nome,
coalesce(e.total_entrada, 0) as total_entrada,
coalesce(s.total_saida, 0) as total_saida,
coalesce(e.total_entrada, 0) - coalesce(s.total_saida, 0) as saldo
from produtos p
left join (
	select id_produto, sum(quantidade) as total_entrada
    from entradas
    group by id_produto) e on p.id_produto = e.id_produto
left join (
	select id_produto, sum(quantidade) as total_saida
    from saidas
    group by id_produto) s on p.id_produto = s.id_produto;
 

-- Produtos que precisam de reposição
select
p.nome as produto_reposição,
p.estoque_minimo
from produtos p
where p.estoque < p.estoque_minimo;


-- Produto com maior valor em estoque 
select
p.nome,
(p.preco * p.estoque) as valor
from produtos p
order by valor desc
limit 1;
