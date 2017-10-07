--六曜的虹光丘儿
function c12001022.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12001022.matfilter,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001022,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c12001022.target)
	e1:SetOperation(c12001022.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12001022.desreptg)
	e2:SetValue(c12001022.desrepval)
	e2:SetOperation(c12001022.desrepop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c12001022.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c12001022.desfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c12001022.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	if chk==0 then return eg:IsExists(c12001022.repfilter,1,nil,tp)
		and g:IsExists(c12001022.desfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,c12001022.desfilter,1,1,nil,tp)
		e:SetLabelObject(sg:GetFirst())
		Duel.HintSelection(sg)
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c12001022.desrepval(e,c)
	return c12001022.repfilter(c,e:GetHandlerPlayer())
end
function c12001022.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c12001022.matfilter(c)
	return c:IsSetCard(0xfb0)
end
function c12001022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	local p=c:GetControler()
	local zone=bit.band(c:GetLinkedZone(),0x1f)
	if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
		and Duel.SelectYesNo(tp,aux.Stringid(12001022,1)) then
		Duel.BreakEffect()
		local s=0
		if c:IsControler(tp) then
			local flag=bit.bxor(zone,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		else
			local flag=bit.bxor(zone,0xff)*0x10000
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
		end
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleDeck(nil)
end
end