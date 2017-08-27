--口袋妖怪 大岩蛇
function c80000187.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),4,2)
	c:EnableReviveLimit()  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000187,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c80000187.cost)
	e1:SetTarget(c80000187.target)
	e1:SetOperation(c80000187.operation)
	c:RegisterEffect(e1)  
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000187,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c80000187.seqcon)
	e3:SetOperation(c80000187.seqop)
	c:RegisterEffect(e3)
end
function c80000187.indval(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000187.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000187.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	local dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if dc then g:AddCard(dc) end
	dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if dc then g:AddCard(dc) end
	if chk==0 then return g:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000187.operation(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	Duel.Destroy(g,REASON_EFFECT)
end
function c80000187.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c80000187.seqop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.bor(flag,bit.lshift(0x1,seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.bor(flag,bit.lshift(0x1,seq+1)) end
		flag=bit.bxor(flag,0xff)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(e:GetHandler(),nseq)
	end
end