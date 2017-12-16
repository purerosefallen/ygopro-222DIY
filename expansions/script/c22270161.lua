--链接设计者
function c22270161.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22270161.matfilter,1,1)
	--change link arrow
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270161,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,222701611)
	e1:SetTarget(c22270161.tg)
	e1:SetOperation(c22270161.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22270161,9))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,222701612)
	e2:SetCost(c22270161.cost)
	e2:SetTarget(c22270161.sptg)
	e2:SetOperation(c22270161.spop)
	c:RegisterEffect(e2)
end
function c22270161.matfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c22270161.tg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK)
end
function c22270161.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=g:GetFirst():GetTextAttack()
	e:SetLabel(atk)
end
function c22270161.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local la=Duel.SelectOption(tp,aux.Stringid(22270161,0),aux.Stringid(22270161,1),aux.Stringid(22270161,2),aux.Stringid(22270161,3),aux.Stringid(22270161,4),aux.Stringid(22270161,5),aux.Stringid(22270161,6),aux.Stringid(22270161,7))
	e:SetLabel(la)
end
function c22270161.op(e,tp,eg,ep,ev,re,r,rp)
	local la=0
	if e:GetLabel()==0 then la=0x040
	elseif e:GetLabel()==1 then la=0x080
	elseif e:GetLabel()==2 then la=0x100
	elseif e:GetLabel()==3 then la=0x020
	elseif e:GetLabel()==4 then la=0x004
	elseif e:GetLabel()==5 then la=0x002
	elseif e:GetLabel()==6 then la=0x001
	elseif e:GetLabel()==7 then la=0x008
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(710253)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(la)
	c:RegisterEffect(e1,true)
end
function c22270161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMutualLinkedGroup():Filter(Card.IsDestructable,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.Destroy(g,REASON_COST)
end
function c22270161.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22270161.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22270161.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c22270161.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22270161.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end