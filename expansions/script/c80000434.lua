--ＰＭ 垃垃藻
function c80000434.initial_effect(c)
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)   
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000434,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000434.damtg)
	e2:SetOperation(c80000434.damop)
	c:RegisterEffect(e2) 
end
function c80000434.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c80000434.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dam=c:GetFlagEffectLabel(80000434)
	if dam==nil then
		c:RegisterFlagEffect(80000434,RESET_EVENT+0x1fe0000,0,0,200)
		dam=200
	else
		dam=dam*2
		c:SetFlagEffectLabel(80000434,dam)
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT,true)
end