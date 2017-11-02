<div class="container">
<div class="row">
    <div class="col-md-8 col-md-offset-2">
        <div class="panel panel-default">
            <div class="panel-heading">@lang('global.sign')</div>
            <div class="panel-body">
                <form class="form-horizontal" role="form" method="POST" action="{{ route('sign') }}">
                    {{ csrf_field() }}
                    <input type="submit" name="sign" value="sign">
                </form>
            </div>
        </div>
    </div>
</div>