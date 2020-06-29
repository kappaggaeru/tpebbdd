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
      <th scope="col">descripción</th>
    </tr>
  </thead>
  <tbody>
  
    {foreach from=$Juegos item=juego}
              <tr>
                <td>{$juego['nombre_juego']}</td>
                <td>{$juego['descripcion_juego']}</td>
              </tr>
    {/foreach}
  </tbody>
</table>
</div>

{include file="footer.tpl"}
