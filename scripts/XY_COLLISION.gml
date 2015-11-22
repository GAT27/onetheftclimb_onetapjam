
var ground = argument0;
var hit,hits;
hits[0] = 0;
if !instance_exists(ground)
    return hits;
var no_wall = ds_queue_create();
var bsx = floor((bbox_right-bbox_left)/2) - 1;//31
var bsy = floor((bbox_bottom-bbox_top)/2) - 1;//31
var xc = bbox_left + bsx;
var yc = bbox_top + bsx;

//X collision
if !((argument1>>1)&1)
{   var ld = abs(hspeed);
    /*if !collision_rectangle(xc-bsx,yc-bsy,xc+bsx,yc+bsy,ground,false,true)*/ do
    {   var groundb = collision_rectangle(xc,yc-bsy,xc + bsx*sign(hspeed) + hspeed,yc+bsy,ground,false,true);
        if groundb
        {   ld = min(ld,distance_to_object(groundb));
            ds_queue_enqueue(no_wall,groundb);
            instance_deactivate_object(groundb);
        }
    }until !groundb
    
    if !ds_queue_empty(no_wall)
    {   x += sign(hspeed) * ld;
        //hspeed = 0;
        //a_speed *= 0.7;
        hits[0] = 1;
        while !ds_queue_empty(no_wall)
        {   hits[array_length_1d(hits)] = ds_queue_dequeue(no_wall);
            instance_activate_object(hits[array_length_1d(hits)-1]);
        }
    }
}

//Y collision
if !(argument1&1)
{   ld = abs(vspeed);
    /*if vspeed >= 0*/ do
    {   groundb = collision_rectangle(xc-bsx,yc+bsy,xc+bsx,yc + bsy*sign(vspeed) + vspeed,ground,false,true);
        if groundb
        {   ld = min(ld,distance_to_object(groundb));
            ds_queue_enqueue(no_wall,groundb);
            instance_deactivate_object(groundb);
        }
    }until !groundb
    
    if !ds_queue_empty(no_wall)
    {   y += sign(vspeed) * ld;
        //vspeed = 0;
        //grounded = 1;
        //jumps = ex_jumps;
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
    //else
      //  grounded = 0;
}

ds_queue_destroy(no_wall);
return hits;

