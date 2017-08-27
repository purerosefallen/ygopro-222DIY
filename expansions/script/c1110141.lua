--幸运与祝福的灵使·蓿
function c1110141.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110141,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1110141)
	e1:SetTarget(c1110141.tg1)
	e1:SetOperation(c1110141.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110141,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1110146)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c1110141.tg2)
	e2:SetOperation(c1110141.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(function(e,se,sp,st)
		return c1110141.filter3x(se:GetHandler())
	end)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c1110141.tg4)
	e4:SetOperation(c1110141.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DICE+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c1110141.cost5)
	e5:SetTarget(c1110141.tg5)
	e5:SetOperation(c1110141.op5)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_DECK)
	e6:SetCountLimit(1)
	e6:SetCost(c1110141.cost6)
	e6:SetCondition(c1110141.con6)
	e6:SetTarget(c1110141.tg6)
	e6:SetOperation(c1110141.op6)
	c:RegisterEffect(e6)
--
end
--
c1110141.named_with_Ld=1
function c1110141.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110141.tfilter1(c,e,tp)
	return (c:IsCode(1110001) or c:IsCode(1110121)) and c:IsAbleToGrave() and c:IsFaceup()
end
function c1110141.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110141.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1110141.tfilter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1110141.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1110141.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c1110141.tfilter2x1(c)
	return c:IsSSetable() and c:IsCode(1111004)
end
function c1110141.tfilter2x2(c)
	return c:IsCode(1111001) and c:IsAbleToGrave()
end
function c1110141.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c1110141.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not Duel.IsExistingMatchingCard(c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,nil) then
		local sel=Duel.SelectOption(tp,aux.Stringid(1110141,0))
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.SSet(tp,tc)~=0 then
					Duel.ConfirmCards(1-tp,g2)
				end
			end
		end
	else
		if Duel.IsExistingMatchingCard(c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,nil) then
			local sel=Duel.SelectOption(tp,aux.Stringid(1110141,0),aux.Stringid(1110141,1))
			if sel==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					if Duel.SSet(tp,tc)~=0 then
						Duel.ConfirmCards(1-tp,tc)
					end
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		else
			if not (Duel.IsExistingMatchingCard(c1110141.tfilter2x1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and Duel.IsExistingMatchingCard(c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,nil) then
				local sel=Duel.SelectOption(tp,aux.Stringid(1110141,1))
				if sel==0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=Duel.SelectMatchingCard(tp,c1110141.tfilter2x2,tp,LOCATION_DECK,0,1,1,nil)
					if g:GetCount()>0 then
						local tc=g:GetFirst()
						Duel.SendtoGrave(tc,REASON_EFFECT)
					end
				end
			end
		end
	end
end
--
function c1110141.filter3x(c)
	return c1110141.IsLd(c)
end
--
function c1110141.tfilter4(c)
	return c:IsAbleToHand()
end
function c1110141.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110141.tfilter4,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1110141.tfilter4,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_ONFIELD)
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1110141.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110141.tfilter4,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
function c1110141.cfilter5(c,e,tp)
	return c:IsCode(1110151) and c:IsAbleToRemoveAsCost()
end
function c1110141.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110141.cfilter5,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1110141.cfilter5,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1110141.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
--
function c1110141.op5(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--
function c1110141.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_EXTRA)
end
--
function c1110141.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
--
function c1110141.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
--
function c1110141.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
--
