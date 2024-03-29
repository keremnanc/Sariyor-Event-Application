<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Events extends Model
{
    use HasFactory;

    protected $table = 'events';

    protected $fillable = ['name', 'description', 'owner_id', 'cat_id', 'lat', 'long', 'start_time', 'only_friends', 'end_time', 'join_start_time', 'join_end_time', 'count', 'image_path'];

    protected $hidden = ['owner_id', 'cat_id'];

    protected $casts = [
        'only_friends' => 'boolean',
        'count' => 'int',
        'lat' => 'float',
        'long' => 'float',
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'join_start_time' => 'datetime',
        'join_end_time' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    protected $appends = ['is_joined'];

    public function user(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(User::class, 'id', 'owner_id');
    }

    public function category(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Categories::class, 'id', 'cat_id');
    }

    public function search(): \Illuminate\Support\Collection
    {
        $event = self::query()->first();
        $user = $this->hasOne(User::class, 'id', 'owner_id')->first();
        $category = $this->hasOne(Categories::class, 'id', 'cat_id')->first();
        return collect([$event, $user, $category]);
    }

    public function getIsJoinedAttribute(){
        return $this->hasMany(JoinedEvent::class,'event_id','id')->where('user_id',Auth::id())->exists();
    }
}
