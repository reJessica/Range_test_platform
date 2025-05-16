<template>
    <div id="app1">
        <div class="input-group">
            <input class="input" id="Email" name="Email" placeholder="请输入网址" autocomplete="off">
            <input class="button--submit" value="开始检测" type="submit">
        </div>
    </div>
</template>
<script>
</script>
<style scope>
* {
    margin: 0;
    padding: 0;
}

#app1 {
    width: 100%;
    height: 100vh;
    justify-content: center;
    align-items: center;
    background: url(../../assets/ai/backround1.jpg) no-repeat;
    background-size: 100% 100%;
}

.input-group {
    display: flex;
    align-items: center;
    justify-content: center;
    /* height:100%; */
    margin-top: 15%;
}

.input {
    min-height: 50px;
    max-width: 450px;
    width: 400px;
    padding: 0 1rem;
    color: #fff;
    font-size: 15px;
    border: 1px solid #5e4dcd;
    border-radius: 6px 0 0 6px;
    background-color: transparent;
}

.button--submit {
    min-height: 50px;
    padding: .5em 1em;
    border: none;
    border-radius: 0 6px 6px 0;
    background-color: #5e4dcd;
    color: #fff;
    font-size: 15px;
    cursor: pointer;
    transition: background-color .3s ease-in-out;
}

.button--submit:hover {
    background-color: #5e5dcd;
}

.input:focus,
.input:focus-visible {
    border-color: #3898EC;
    outline: none;
}
</style>