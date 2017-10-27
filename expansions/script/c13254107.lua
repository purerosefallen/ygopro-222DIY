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
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c13254107.thtg)
	e2:SetOperation(c13254107.thop)
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
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(13254107,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c13254107.descon)
	e8:SetTarget(c13254107.destg)
	e8:SetOperation(c13254107.desop)
	c:RegisterEffect(e8)
	
end
function c13254107.lfilter(c)
	return c:IsFusionSetCard(0x356) and c:IsReleasable()
end
function c13254107.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13254107.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end
function c13254107.thfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c13254107.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c13254107.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254107.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c13254107.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c13254107.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
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
function c13254107.cfilter(c,tp)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c13254107.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c13254107.cfilter,1,nil,tp)
end
function c13254107.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13254107.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
