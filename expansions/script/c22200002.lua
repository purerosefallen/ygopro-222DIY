--幽灵欺诈
function c22200002.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22200002.hspcon)
	e1:SetOperation(c22200002.hspop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22200002.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22200002,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22200002.tg)
	e2:SetOperation(c22200002.op)
	c:RegisterEffect(e2)
end
function c22200002.spfilter(c)
	local g=c:GetOverlayGroup()
	return c:IsType(TYPE_XYZ) and g:GetCount()>0 and g:IsExists(Card.IsAbleToGraveAsCost,1,nil)
end
function c22200002.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22200002.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22200002.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22200002,0))
	local g=Duel.SelectMatchingCard(tp,c22200002.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g:GetFirst():GetOverlayGroup(),REASON_COST)		 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(g:GetFirst():GetRank())
	e1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1)
end
function c22200002.disable(e,c)
	return (c:IsType(TYPE_XYZ) or bit.band(c:GetOriginalType(),TYPE_XYZ)==TYPE_XYZ) and c:GetRank()==e:GetHandler():GetLevel()
end
function c22200002.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c22200002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22200002.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22200002.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22200002.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c22200002.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler() 
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
	local nseq=0
	if s==1 then nseq=0
	elseif s==2 then nseq=1
	elseif s==4 then nseq=2
	elseif s==8 then nseq=3
	else nseq=4 end 
	Duel.MoveSequence(tc,nseq)
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetRank()+tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end  
end