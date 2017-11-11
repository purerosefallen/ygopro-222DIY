--灵曲·凌霜空幽之雪
function c1111224.initial_effect(c)
--
	c:EnableCounterPermit(0x1111)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111224,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1111224) 
	e1:SetCost(c1111224.cost1)
	e1:SetTarget(c1111224.tg1)
	e1:SetOperation(c1111224.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111224,1))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1111229) 
	e2:SetCost(c1111224.cost2)
	e2:SetTarget(c1111224.tg2)
	e2:SetOperation(c1111224.op2)
	c:RegisterEffect(e2)
--
end
--
c1111224.named_with_Lq=1
function c1111224.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111224.cfilter1(c)
	return c:IsReleasable() and c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
end
function c1111224.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111224.cfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)	
	local g=Duel.SelectMatchingCard(tp,c1111224.cfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
end
--
function c1111224.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,LOCATION_ONFIELD)
end
--
function c1111224.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1111,1)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetRange(LOCATION_SZONE)
		e1_1:SetCountLimit(1)
		e1_1:SetCode(EVENT_PHASE+PHASE_END)
		e1_1:SetOperation(c1111224.op1_1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1_1)
	end
end
function c1111224.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--
function c1111224.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1111,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1111,2,REASON_COST)
end
--
function c1111224.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,LOCATION_ONFIELD)
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1111224.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(e:GetHandler())
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_2:SetCode(EFFECT_DISABLE)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(e:GetHandler())
		e2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetCode(EFFECT_DISABLE_EFFECT)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_3)
		local e2_4=Effect.CreateEffect(e:GetHandler())
		e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_4:SetType(EFFECT_TYPE_SINGLE)
		e2_4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e2_4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_4)
		local e2_5=Effect.CreateEffect(e:GetHandler())
		e2_5:SetType(EFFECT_TYPE_SINGLE)
		e2_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_5:SetCode(EFFECT_CANNOT_ATTACK)
		e2_5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_5)
		local e2_6=Effect.CreateEffect(e:GetHandler())
		e2_6:SetType(EFFECT_TYPE_SINGLE)
		e2_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2_6:SetValue(1)
		e2_6:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_6)   
		local e2_7=Effect.CreateEffect(e:GetHandler())
		e2_7:SetType(EFFECT_TYPE_SINGLE)
		e2_7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2_7:SetValue(1)
		e2_7:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_7)
		local e2_8=Effect.CreateEffect(e:GetHandler())
		e2_8:SetType(EFFECT_TYPE_SINGLE)
		e2_8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2_8:SetValue(1)
		e2_8:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_8)
		local e2_9=Effect.CreateEffect(e:GetHandler())
		e2_9:SetType(EFFECT_TYPE_SINGLE)
		e2_9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_9:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2_9:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_9)
		local e2_10=Effect.CreateEffect(e:GetHandler())
		e2_10:SetType(EFFECT_TYPE_SINGLE)
		e2_10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2_10:SetValue(1)
		e2_10:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_10)
	end
end



