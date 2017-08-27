--传说中的口袋妖怪 玛娜菲
function c80000081.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
--xyz summon
	aux.AddXyzProcedure(c,c80000081.ffilter,3,5)
	c:EnableReviveLimit()
--spsummon limit
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c80000081.splimit)
	c:RegisterEffect(e5)
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80000081.atkval)
	c:RegisterEffect(e1) 
--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000081.efilter)
	c:RegisterEffect(e2) 
--defind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80000081.atkval)
	c:RegisterEffect(e3)  
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000081,1))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80000081.condition1)
	e4:SetCost(c80000081.cost)
	e4:SetTarget(c80000081.drtg)
	e4:SetOperation(c80000081.drop)
	c:RegisterEffect(e4)  
--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(80000081,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,80000081+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c80000081.condition)
	e6:SetCost(c80000081.cost2)
	e6:SetTarget(c80000081.target2)
	e6:SetOperation(c80000081.operation2)
	c:RegisterEffect(e6)  
	--Attribute Dark
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e7)
end
function c80000081.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x2d0)
end
function c80000081.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x2d0)
end
function c80000081.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000081.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c80000081.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000081.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end 
function c80000081.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000081.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht<4 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4-ht)
	end
end
function c80000081.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<4 then
		Duel.Draw(p,4-ht,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
end
function c80000081.filter2(c,e,tp)
	return c:IsCode(80000146) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80000081.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,5,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,5,5,REASON_COST+REASON_DISCARD)
end
function c80000081.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000081.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80000081.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000081.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end