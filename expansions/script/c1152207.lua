--禁弹『刻着过去的钟表』
function c1152207.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1152207.con1)
	e1:SetCost(c1152207.cost1)
	e1:SetTarget(c1152207.tg1)
	e1:SetOperation(c1152207.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1152207.con2)
	e2:SetCost(c1152207.cost2)
	e2:SetTarget(c1152207.tg2)
	e2:SetOperation(c1152207.op2)
	c:RegisterEffect(e2)
--
end
--
function c1152207.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152207.named_with_Fulsp=1
function c1152207.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152207.cfilter1(c)
	return c:IsFaceup() and c1152207.IsFulan(c)
end
function c1152207.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1152207.cfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,1152206)==0
end
--
function c1152207.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetOriginalCode()==1152207 then
		Duel.RegisterFlagEffect(tp,1152207,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c1152207.tfilter1(c)
	return c1152207.IsFulsp(c) and not c:IsCode(1152207) and c:CheckActivateEffect(true,true,false)~=nil
end
function c1152207.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c1152207.tfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1152207.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
--
function c1152207.op1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
	e:GetHandler():CancelToGrave()
end
--
function c1152207.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and Duel.GetFlagEffect(tp,1152207)==0
end
--
function c1152207.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetOriginalCode()==1152207 then
		Duel.RegisterFlagEffect(tp,1152206,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c1152207.tfilter2(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable() and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function c1152207.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c1152207.tfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(c1152207.tfilter2,tp,LOCATION_GRAVE,0,e:GetHandler())>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1152207.tfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
--
function c1152207.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--