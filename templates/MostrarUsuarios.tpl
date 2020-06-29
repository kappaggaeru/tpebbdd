{include file="header.tpl"}
<div class="card text-center">
  <div class="card-body">
    <h3 class="card-title">Lista de usuarios</h3>
  </div>
</div>
<div  class="row justify-content-md-center" >
<table class="table col-9 md-auto" >
  <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">Nombre</th>
      <th scope="col">Apellido</th>
      <th scope="col">Email</th>
    </tr>
  </thead>
  <tbody>
  
    {foreach from=$Usuarios item=usuario}
              <tr>
                <th scope="row">{$usuario['id_usuario']}</th>
                <td>{$usuario['nombre']}</td>
                <td>{$usuario['apellido']}</td>
                <td>{$usuario['email']}</td>
              </tr>
    {/foreach}
  </tbody>
</table>
</div>


{include file="footer.tpl"}
