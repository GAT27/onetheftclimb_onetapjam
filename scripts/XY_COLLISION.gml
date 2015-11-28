
var ground = argument0;
var hit,hits;
hits[0] = 0;
if !instance_exists(ground)
    return hits;
var no_wall = ds_queue_create();
var bsx = floor((bbox_right-bbox_left)/2) - 1;
var bsy = floor((bbox_bottom-bbox_top)/2) - 1;
var xc = bbox_left + bsx;
var yc = bbox_top + bsy;

//X collision
if !((argument1>>1)&1)
{   var spd = hspeed;
    if hspeed == 0
        spd = x - xprevious;
    var ld = abs(spd);
    /*if !collision_rectangle(xc-bsx,yc-bsy,xc+bsx,yc+bsy,ground,false,true)*/ do
    {   var groundb = collision_rectangle(xc,yc-bsy,xc + bsx*sign(spd) + spd,yc+bsy,ground,false,true);
        if groundb
        {   ld = min(ld,distance_to_object(groundb));
            ds_queue_enqueue(no_wall,groundb);
            instance_deactivate_object(groundb);
        }
    }until !groundb
    
    if !ds_queue_empty(no_wall)
    {   x += sign(spd) * ld;
        hits[0] = 1;
        while !ds_queue_empty(no_wall)
        {   hits[array_length_1d(hits)] = ds_queue_dequeue(no_wall);
            instance_activate_object(hits[array_length_1d(hits)-1]);
        }
    }
}

//Y collision
if !(argument1&1)
{   var spd = vspeed;
    if vspeed == 0
        spd = y - yprevious;
    var ld = abs(spd);
    /*if vspeed >= 0*/ do
    {   groundb = collision_rectangle(xc-bsx,yc,xc+bsx,yc + bsy*sign(spd) + spd,ground,false,true);
        if groundb
        {   ld = min(ld,distance_to_object(groundb));
            ds_queue_enqueue(no_wall,groundb);
            instance_deactivate_object(groundb);
        }
    }until !groundb
    
    if !ds_queue_empty(no_wall)
    {   y += sign(spd) * ld;
        hits[0] = 1;
        while !ds_queue_empty(no_wall)
        {   hit = ds_queue_dequeue(no_wall);
            instance_activate_object(hit);
            var hitt = 0;
            for (var i=1;i<array_length_1d(hits);i++)
                if hits[i] == hit
                {   hitt = 1;
                    break;
                }
            if !hitt
                hits[array_length_1d(hits)] = hit
        }
    }
}

ds_queue_destroy(no_wall);
return hits;

