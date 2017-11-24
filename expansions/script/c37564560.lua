--超超光速出前最速!!!
local m=37564560
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	Senya.AddSummonMusic(c,m*16+1,SUMMON_TYPE_LINK)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,2,2,cm.lcheck)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTarget(function(e,c)
		return e:GetHandler():GetLinkedGroup():IsContains(c)
	end)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(0)
	e4:SetTarget(function(e,c)
		return e:GetHandler():GetLinkedGroup():IsContains(c)
	end)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.mfilter(c)
	return c:IsFaceup() and c:IsCode(37564765)
end
function cm.lcheck(g)
	return g:IsExists(cm.lfilter,1,nil,g)
end
function cm.lfilter(c,g)
	local cg=c:GetColumnGroup()
	return g:IsExists(function(tc) return cg:IsContains(tc) end,1,c)
end
function cm.location_check(p,tp,z)
	local tz=0
	if p~=tp then
		tz=bit.rshift(bit.band(z,0x1f0000),16)
	else
		tz=bit.band(z,0x1f)
	end
	local ct=0
	local res=0
	for i=0,4 do
		local cz=bit.lshift(1,i)
		if bit.band(tz,cz)==cz and Duel.CheckLocation(p,LOCATION_MZONE,i) then
			ct=ct+1
			res=bit.bor(cz,res)
		end
	end
	if p~=tp then res=bit.lshift(res,16) end
	return ct,res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not re:IsActiveType(TYPE_MONSTER) or not re:GetHandler():IsOnField() then return false end
		local c=e:GetHandler()
		local rc=re:GetHandler()
		local p=rc:GetControler()
		local z=c:GetLinkedZone()
		if z==0 then return false end
		local ct,res=cm.location_check(p,tp,z)
		return ct>0
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not c:IsRelateToEffect(e) or not rc:IsRelateToEffect(re) or not cm.target(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local p=rc:GetControler()
	local z=c:GetLinkedZone()
	local ct,res=cm.location_check(p,tp,z)
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local sz=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x1f001f-res)
	if bit.band(sz,0x1f0000)~=0 then sz=bit.rshift(sz,16) end
	Duel.MoveSequence(rc,math.log(sz,2))
end