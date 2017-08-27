--要塞飞球
function c13254107.initial_effect(c)
	c:SetUniqueOnField(1,0,13254107)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c13254107.lfilter),2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c13254107.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254107,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c13254107.cost)
	e2:SetCondition(c13254107.drcon)
	e2:SetTarget(c13254107.drtg)
	e2:SetOperation(c13254107.drop)
	c:RegisterEffect(e2)
	--[local e3=Effect.CreateEffect(c)
	--e3:SetDescription(1163)
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCondition(c13254107.spcon)
	--e3:SetOperation(c13254107.spop)
	--e3:SetValue(SUMMON_TYPE_SPECIAL)
	--c:RegisterEffect(e3)
	--damage 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c13254107.reptg)
	e6:SetOperation(c13254107.repop)
	c:RegisterEffect(e6)
	--splimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c13254107.splimit)
	c:RegisterEffect(e7)
	
end
function c13254107.lfilter(c)
	return c:IsFusionSetCard(0x356) and c:IsReleasable()
end
function c13254107.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13254107.cfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c13254107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254107.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local cg=Duel.GetMatchingGroup(c13254107.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=cg:GetCount()
	if ct>4 then ct=4 end
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
	e:SetLabel(ct)
end
function c13254107.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end
function c13254107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c13254107.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c13254107.spfilter(c,e,tp)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c13254107.spcon(e,c,sg,og)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13254107.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c13254107.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254107.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	sg:Merge(g)
end
function c13254107.repfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER)
end
function c13254107.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c13254107.repfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(13254107,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c13254107.repfilter,tp,LOCATION_HAND,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c13254107.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
end
function c13254107.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x356) or not c:IsType(TYPE_MONSTER)
end
