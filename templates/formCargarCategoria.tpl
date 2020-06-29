{include file="header.tpl"}
<form action="cargarCategoria" method="post">
	<div class="form-group">
    <label for="exampleFormControlTextarea1">Descripcion categoria</label>
    <textarea name="descripcion" class="form-control" id="exampleFormControlTextarea1" rows="3"></textarea>
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect1">Nivel de tarea</label>
    <select name="nivel" class="form-control" id="exampleFormControlSelect1">
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
    </select>
  </div>
  <input type="submit" value="ENTRAR" name="enviar" class="registrado">
</form>
{include file="footer.tpl"}