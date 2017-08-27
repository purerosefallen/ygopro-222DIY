--七大魔王 究极愤怒
function c80021020.initial_effect(c)
	c:SetUniqueOnField(1,1,80021020)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa2d5),7,3,c80021020.ovfilter,aux.Stringid(80021020,0),3,c80021020.xyzop)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)  
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c80021020.sumlimit)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c80021020.aclimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80021020.efilter)
	c:RegisterEffect(e2)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80021020,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1,80021020)
	e4:SetCost(c80021020.atkcost)
	e4:SetOperation(c80021020.atkop)
	c:RegisterEffect(e4)
end
function c80021020.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c80021020.cfilter(c)
	return c:IsSetCard(0xa2d5) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c80021020.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80021006)
end
function c80021020.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80021020.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80021020.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80021020.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsType(TYPE_MONSTER)
end
function c80021020.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:GetActivateLocation()==LOCATION_REMOVED 
end
function c80021020.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,2,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,1,2,2,REASON_COST)
end
function c80021020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(c80021020.damval)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c80021020.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 and rc==e:GetHandler() then
		return dam/2
	else return dam end
end