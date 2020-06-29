{include file="header.tpl"}
<div class="formLogin">
  <form action="verificarLogin" method="post">
    <div class="form-group">
      <label for="exampleInputEmail1">Email</label>
      <input name="email" type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp">
    </div>
    <div class="form-group">
      <label for="exampleInputPassword1">Contraseña</label>
      <input name="password" type="password" class="form-control" id="exampleInputPassword1">
    </div>
    <button type="submit" class="btn btn-success btn-lg btn-block" name="enviar">Ingresar</button>
    {* <input type="submit" value="ENTRAR"  class="registrado"> *}
  </form>
</div>
{include file="footer.tpl"}