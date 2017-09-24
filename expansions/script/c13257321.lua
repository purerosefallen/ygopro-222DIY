--里超时空战斗机-Raiden
function c13257321.initial_effect(c)
	c:EnableCounterPermit(0x351)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257321,4))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c13257321.eqtg)
	e1:SetOperation(c13257321.eqop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257321,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c13257321.pctg)
	e2:SetOperation(c13257321.pcop)
	c:RegisterEffect(e2)
	--bomb
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257321,6))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c13257321.bombcost)
	e3:SetTarget(c13257321.bombtg)
	e3:SetOperation(c13257321.bombop)
	c:RegisterEffect(e3)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257321.bgmop)
	c:RegisterEffect(e11)
	c13257321[c]=e2
	
end
function c13257321.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257321.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257321.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257321.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257321.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257321.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=c:GetEquipCount()>0 or Duel.IsExistingMatchingCard(c13257321.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local t2=Duel.IsCanAddCounter(tp,0x351,1,c)
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257321,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257321,2),aux.Stringid(13257321,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257321,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257321,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x351)
	end
end
function c13257321.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local eq=c:GetEquipGroup()
		local g=eq:Filter(Card.IsAbleToDeck,nil)
		local op=0
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13257321,5)) then op=1
		elseif Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and g:GetCount()>0 then op=1
		end
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g=Duel.SelectMatchingCard(tp,c13257321.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		if c:IsRelateToEffect(e) then
			c:AddCounter(0x351,1)
		end
	end
end
function c13257321.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x351,1,REASON_COST)
end
function c13257321.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c13257321.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e4)
end
function c13257321.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13257321.acfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c13257321.desfilter(c)
	return c:IsFaceup() and (c:GetAttack()==0 or (c:GetDefense()==0 and not c:IsType(TYPE_LINK)))
end
function c13257321.bombop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257321.acfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-1000)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
		g=Duel.GetMatchingGroup(c13257324.desfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c13257321.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257321,7))
end
