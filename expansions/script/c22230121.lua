--Darkest　死灵法师
function c22230121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_FLIP),3,2)
	c:EnableReviveLimit()
	--Overlay
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22230121,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c22230121.olcon)
	e4:SetOperation(c22230121.olop)
	c:RegisterEffect(e4)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22230121,1))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_MAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c22230121.poscon)
	e6:SetCost(c22230121.poscost)
	e6:SetTarget(c22230121.postg)
	e6:SetOperation(c22230121.posop)
	c:RegisterEffect(e6)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230121,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c22230121.sptg)
	e1:SetOperation(c22230121.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230121.flipop)
	c:RegisterEffect(e2)
end
c22230121.named_with_Darkest_D=1
function c22230121.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230121.cfilter(c,tp)
	return c22230121.IsDarkest(c) and c:IsType(TYPE_FLIP) and c:IsType(TYPE_MONSTER)
end
function c22230121.olcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22230121.cfilter,1,nil,tp)
end
function c22230121.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.Overlay(c,sg)
end
function c22230121.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22230121.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22230121.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22230121.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22230121.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22230121.posfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22230121.posfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,0,2,0,0)
end
function c22230121.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
function c22230121.spfilter(c)
	return c22230121.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c22230121.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and g:IsExists(c22230121.spfilter,1,nil) end
	if e:GetHandler():GetFlagEffect(22230121)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230121)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c22230121.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(c22230121.spfilter,1,nil)
	if g:GetCount()<1 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		if e:GetLabel()==1 and sc:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(22230121,3)) then
			Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c22230121.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230121,0,0,0)
end




