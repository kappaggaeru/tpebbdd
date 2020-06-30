{include file="header.tpl"}
<div class="card text-center">
  <div class="card-body">
    <h3 class="card-title">Lista de usuarios</h3>
  </div>
  

</div>

<div class="container">
    <div class="col  Align-self-center">
        <form class="form-inline" method="Post" action="buscarUser">
            <input class="form-control mr-sm-2" type="search" placeholder="Nombre" name="buscador" aria-label="Search">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Buscar</button>
          </form>
    </div>
</div>
<br>
<br>


<div  class="row justify-content-md-center" >
<table class="table col-9 md-auto" >
  <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">Nombre</th>
      <th scope="col">Apellido</th>
      <th scope="col">Email</th>
      <th scope="col">Votos</th>
      <th scope="col">Juegos Jugados</th>
    </tr>
  </thead>
  <tbody>
  
    {foreach from=$Usuarios item=usuario}
    <tr>        
                <th scope="row">{$usuario['id_usuario']}</th>
                <td>{$usuario['nombre']}</td>
                <td>{$usuario['apellido']}</td>
                <td>{$usuario['email']}</td>
                <td>{$usuario[0]['votos']}</td>
                <td>{$usuario[1]['count']}</td>

    </tr>
{/foreach}
  </tbody>
</table>
</div>


{include file="footer.tpl"}
