--太古的星辉
function c10161005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10161005.target1)
	c:RegisterEffect(e1)
	--chooseeffect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10161005,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c10161005.cost)
	e2:SetTarget(c10161005.target)
	e2:SetOperation(c10161005.operation)
	c:RegisterEffect(e2)  
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c10161005.damcon)
	e3:SetValue(c10161005.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4) 
end
c10161005.card_code_list={10160001}
function c10161005.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end

function c10161005.damcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return Duel.GetLP(p)<=1000 
end

function c10161005.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c10161005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	if c10161005.cost(e,tp,eg,ep,ev,re,r,rp,0) and c10161005.target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		and Duel.SelectYesNo(tp,aux.Stringid(10161005,3)) then
		e:SetOperation(c10161005.operation)
		c10161005.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c10161005.target(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c10161005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,10161005)==0 end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(Duel.GetOperatedGroup():GetFirst())
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.RegisterFlagEffect(tp,10161005,RESET_PHASE+PHASE_END,0,1)
end

function c10161005.tgfilter(c)
	return c:IsSetCard(0x9333) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end

function c10161005.thfiter(c)
	return c:IsSetCard(0x9333) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function c10161005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c10161005.tgfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.IsExistingTarget(c10161005.thfiter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,0,1,e:GetLabelObject()) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10161005,1),aux.Stringid(10161005,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10161005,1))
	else
		Duel.SelectOption(tp,aux.Stringid(10161005,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectTarget(tp,c10161005.thfiter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,0,1,1,e:GetLabelObject())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED)
	end
end

function c10161005.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)	 
		local tg=Duel.SelectMatchingCard(tp,c10161005.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()>0 then
		   Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		   Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end


