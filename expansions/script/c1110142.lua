--灵都的希望使者·苜
function c1110142.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110142,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1110142)
	e1:SetTarget(c1110142.tg1)
	e1:SetOperation(c1110142.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110142,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,1110143)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c1110142.cost2)
	e2:SetTarget(c1110142.tg2)
	e2:SetOperation(c1110142.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(function(e,se,sp,st)
		return c1110142.filter3x(se:GetHandler())
	end)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c1110142.tg4)
	e4:SetOperation(c1110142.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c1110142.cost5)
	e5:SetTarget(c1110142.tg5)
	e5:SetOperation(c1110142.op5)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_DECK)
	e6:SetCountLimit(1)
	e6:SetCost(c1110142.cost6)
	e6:SetCondition(c1110142.con6)
	e6:SetTarget(c1110142.tg6)
	e6:SetOperation(c1110142.op6)
	c:RegisterEffect(e6)
end
--
c1110142.named_with_Ld=1
function c1110142.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1110142.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
function c1110142.IsLw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lw
end
--
function c1110142.tfilter1(c,e,tp)
	return (c:IsCode(1110002) or c:IsCode(1110122)) and c:IsAbleToGrave() and c:IsFaceup()
end
function c1110142.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110142.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1110142.tfilter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1110142.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1110142.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c1110142.tfilter2(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_MONSTER)) and c:IsAbleToRemoveAsCost()
end
function c1110142.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110142.tfilter2,tp,LOCATION_HAND,0,1,nil) end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1110142.tfilter2,tp,LOCATION_HAND,0,1,1,nil)	
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c1110142.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
--
function c1110142.ofilter2x1(c)
	return c:IsAbleToRemove()
end
function c1110142.ofilter2x2(c)
	return c1110142.IsLd(c) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c1110142.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() and e:GetLabelObject()~=nil then
		local tc=e:GetLabelObject()
		if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c1110142.ofilter2x1,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110142,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c1110142.ofilter2x1,tp,0,LOCATION_ONFIELD,1,1,nil)	
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		else
			if tc:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c1110142.ofilter2x2,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1110142,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c1110142.ofilter2x2,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					if Duel.SSet(tp,tc)~=0 then
						Duel.ConfirmCards(1-tp,tc)
					end
				end
			end
		end
	end
end
--
function c1110142.filter3x(c)
	return c1110142.IsLd(c)
end
--
function c1110142.tfilter4(c)
	return c:IsAbleToDeck() and c:IsFaceup()
end
function c1110142.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110142.tfilter4,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_REMOVED)
end
--
function c1110142.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1110142.tfilter4,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function c1110142.cfilter5(c)
	return c1110142.IsLd(c) and c:IsAbleToRemoveAsCost()
end
function c1110142.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(c1110142.cfilter5,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.PayLPCost(tp,800)
	local g=Duel.SelectMatchingCard(tp,c1110142.cfilter5,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
--
function c1110142.tfilter5(c)
	return (c1110142.IsLw(c) or c1110142.IsDw(c)) and c:IsSSetable()
end
function c1110142.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110142.tfilter5,tp,LOCATION_DECK,0,1,nil) end
end
--
function c1110142.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c1110142.tfilter5,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SSet(tp,tc)~=0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
--
function c1110142.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_EXTRA)
end
--
function c1110142.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
--
function c1110142.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
--
function c1110142.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
--

