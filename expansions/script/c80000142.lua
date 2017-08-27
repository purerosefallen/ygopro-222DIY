--传说中的口袋妖怪 比克提尼
function c80000142.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,c80000142.ffilter,3,5)
	c:EnableReviveLimit()
--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000142.splimit)
	c:RegisterEffect(e4)
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80000142.atkval)
	c:RegisterEffect(e1) 
--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000142.efilter)
	c:RegisterEffect(e2) 
--defind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80000142.atkval)
	c:RegisterEffect(e3) 
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000142,0))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c80000142.cost)
	e5:SetTarget(c80000142.tdtg)
	e5:SetOperation(c80000142.tdop)
	c:RegisterEffect(e5)  
	--actlimit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,1)
	e9:SetValue(c80000142.aclimit)
	e9:SetCondition(c80000142.actcon)
	c:RegisterEffect(e9) 
end
function c80000142.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80000142.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c80000142.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000142.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000142.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c80000142.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000142.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end 
function c80000142.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c80000142.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(g:GetCount()*100)
		c:RegisterEffect(e1)
	end
end
function c80000142.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousAttackOnField()>=4900
end
function c80000142.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	end
end