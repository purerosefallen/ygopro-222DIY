--玫瑰香水
function c1150021.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150021.tg1)
	e1:SetOperation(c1150021.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1150021.tfilter1(c)
	return c:IsFaceup()
end
function c1150021.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150021.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150021.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150021.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1150021.ofilter1(c,e,tp)
	local lv=e:GetLabel()
	return c:IsFaceup() and c:IsControlerCanBeChanged() and ((c:IsType(TYPE_XYZ) and c:GetRace()<lv) or (not c:IsType(TYPE_XYZ) and c:GetLevel()<lv))
end
function c1150021.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local g=Duel.TossCoin(tp,1)
		local lv=0
		if g==1 then
			if tc:IsType(TYPE_XYZ) then
				lv=tc:GetRank()+1
			else
				lv=tc:GetLevel()+1
			end
			e:SetLabel(lv)
			if Duel.IsExistingMatchingCard(c1150021.ofilter1,tp,0,LOCATION_MZONE,1,nil,e,tp) then
				local g1=Duel.SelectMatchingCard(tp,c1150021.ofilter1,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
				if g1:GetCount()>0 then
					Duel.GetControl(g1,tp,PHASE_END,1)
				end
			end
		end
		if g==0 then
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetDescription(aux.Stringid(1150021,0))
			e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1_1:SetType(EFFECT_TYPE_QUICK_O)
			e1_1:SetCode(EVENT_CHAINING)
			e1_1:SetRange(LOCATION_MZONE)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			e1_1:SetCondition(c1150021.con1_1)
			e1_1:SetTarget(c1150021.tg1_1)
			e1_1:SetOperation(c1150021.op1_1)
			tc:RegisterEffect(e1_1)
		end
	end
end
--
function c1150021.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return not (re:GetHandler():IsType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_PENDULUM) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
--
function c1150021.tfilter1_1(c)
	return c:IsAbleToHand()
end
function c1150021.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150021.tfilter1_1,rp,0,LOCATION_ONFIELD,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
--
function c1150021.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1150021.op1_1_1)
end
--
function c1150021.op1_1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()~=TYPE_MONSTER+TYPE_CONTINUOUS+TYPE_FIELD+TYPE_PENDULUM then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c1150021.tfilter1_1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

