{include file="header.tpl"}
	<div class="card text-center">
  <div class="card-body">
    <h3 class="card-title">TOP 10 JUEGOS MAS VOTADOS</h3>
  </div>
</div>
<div  class="row justify-content-md-center" >
<table class="table col-9 md-auto" >
  <thead>
    <tr>
      <th scope="col">Nombre Juego</th>
      <th scope="col">Descripción</th>
    </tr>
  </thead>
  <tbody>
    {foreach from=$juegos item=juego}
    <tr>
      <td>{$juego['nombre']}</td>
      <td>{$juego['apellido']}</td>
    </tr>
    {/foreach}
  </tbody>
</table>
</div>

{include file="footer.tpl"}
