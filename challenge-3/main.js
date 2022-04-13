//Please run below code in javascript editior
obj = {"a":{"b":{"c":"d"}}}
key = "a/b/c" //change the key according to requirement

itr_value(obj,key);

function itr_value(o1,k1){
    console.log('Object is ', o1)
    keys = key.split('/')
    console.log('Keys are - ',k1)

    for (let i = 0, len = keys.length; i < len; i++) {
        k = keys[i]
        o1 = o1[k]
    }
    console.log('Value is ',o1)
}