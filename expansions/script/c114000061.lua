--★魔女の肉詰め かずみ
function c114000061.initial_effect(c)
	--summon without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c114000061.ntcon)
	c:RegisterEffect(e1)
end
function c114000061.conremfilter(c)
	return c:IsSetCard(0xcabb)
	and c:IsType(TYPE_MONSTER)
end
function c114000061.con1filter(c)
	return c:IsFaceup()
	and	( c:IsSetCard(0xcabb)
	or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
end
function c114000061.con2filter(c)
	return ( c:IsSetCard(0xcabb)
	or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
	and c:IsType(TYPE_MONSTER)
end
function c114000061.ntcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114000061.conremfilter,tp,LOCATION_REMOVED,0,1,nil)
		and ( Duel.IsExistingMatchingCard(c114000061.con1filter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(c114000061.con2filter,tp,LOCATION_GRAVE,0,1,nil) )
end